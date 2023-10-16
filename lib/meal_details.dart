import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodly/colors.dart';
import 'package:foodly/isolate_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MealDetails extends StatefulWidget {
  final String imagePath;

  const MealDetails({super.key, required this.imagePath});

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  final IsolateUtils _isolateUtils = IsolateUtils();
  late Map<String, (int, double)> _probabilities = {};
  late Uint8List _image;
  late bool _isLoading;
  bool _showMask = false;

  initialize() async {
    final interpreter = await Interpreter.fromAsset(
      'assets/model.tflite',
      options: InterpreterOptions()..threads = Platform.numberOfProcessors,
    );
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    final labels = labelsData.split('\n');

    await _isolateUtils.start();

    ReceivePort responsePort = ReceivePort();
    final isolateData = IsolateData(
      imageFilePath: widget.imagePath,
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

    final sum = result.values.reduce((a, b) => a + b);
    result = result.map((key, value) => MapEntry(key, (value / sum)));

    result.forEach((key, value) {
      final index = result.keys.toList().indexOf(key);
      final color = categoryColors[index];
      _probabilities[key] = (color, value);
    });

    _probabilities = Map.fromEntries(
      _probabilities.entries.toList()
        ..sort((e1, e2) {
          var (_, first) = e1.value;
          var (_, second) = e2.value;
          return second.compareTo(first);
        }),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        File(widget.imagePath),
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
                color: _showMask ? Colors.lightBlue : Colors.white10,
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
                  "Show food groups",
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
              color: Colors.white10,
            ),
            child: Column(
              children: [
                ..._probabilities.keys.toList().map((className) {
                  var (color, probability) =
                      _probabilities[className] as (int, double);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        className.capitalize(),
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _showMask ? Color(color) : Colors.white,
                          shadows: <Shadow>[
                            const Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        '${(probability * 100).toStringAsFixed(2)}%',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _showMask ? Color(color) : Colors.white,
                          shadows: <Shadow>[
                            const Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
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

extension Capitalize on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
