import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:foodly/utils/colors.dart';
import 'package:foodly/utils/isolate_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:foodly/utils/database_service.dart';

class MealDetails extends StatefulWidget {
  final Uint8List imageBytes;
  final bool? saveToHistory;

  const MealDetails({super.key, required this.imageBytes, this.saveToHistory});

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  final IsolateUtils _isolateUtils = IsolateUtils();
  late Map<String, Inference> _probabilities = {};
  late Uint8List _image;
  late bool _isLoading;
  bool _showMask = false;

  _initialize() async {
    final interpreter = await Interpreter.fromAsset(
      'assets/model.tflite',
      options: InterpreterOptions()..threads = Platform.numberOfProcessors,
    );
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    final labels = labelsData.split('\n');

    await _isolateUtils.start();

    ReceivePort responsePort = ReceivePort();
    final isolateData = IsolateData(
      imageBytes: widget.imageBytes,
      interpreterAddress: interpreter.address,
      labels: labels,
      responsePort: responsePort.sendPort,
    );

    _isolateUtils.sendPort.send(isolateData);
    var (result, image) = await responsePort.first as (
      Map<String, double>,
      img.Image,
    );

    List<int> imageBytes = img.encodePng(image);
    _image = Uint8List.fromList(imageBytes);

    interpreter.close();
    _isolateUtils.dispose();

    result.forEach((key, value) {
      final index = result.keys.toList().indexOf(key);
      final color = categoryColors[index];
      _probabilities[key] = Inference(color, value);
    });

    _probabilities = Map.fromEntries(
      _probabilities.entries.toList()
        ..sort((a, b) {
          return b.value.prob.compareTo(a.value.prob);
        }),
    );

    if (widget.saveToHistory ?? false) {
      final db = await DatabaseService().database;
      db.insert(
        'scan_history',
        {
          'image': widget.imageBytes,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Meal details'),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 40,
              bottom: 20,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        widget.imageBytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (_showMask)
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.memory(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _showMask
                    ? Colors.lightBlue
                    : Theme.of(context).colorScheme.primary,
                width: 3.0,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(3),
              onTap: () {
                setState(() {
                  _showMask = !_showMask;
                });
              },
              child: Center(
                child: Text(
                  '${_showMask ? "Hide" : "Show"} food groups',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [
                ..._probabilities.keys.toList().map((className) {
                  final inference = _probabilities[className]!;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        className.capitalize(),
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _showMask
                              ? Color(inference.color)
                              : Provider.of<ThemeProvider>(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        '${(inference.prob * 100).toStringAsFixed(2)}%',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _showMask
                              ? Color(inference.color)
                              : Provider.of<ThemeProvider>(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class Inference {
  final int color;
  final double prob;

  Inference(this.color, this.prob);
}

extension Capitalize on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
