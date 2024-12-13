import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodly/providers/history_provider.dart';
import 'package:foodly/providers/locale_provider.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:foodly/utils/colors.dart';
import 'package:foodly/utils/isolate_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class MealDetails extends StatefulWidget {
  final String? imagePath;
  final String? imageUrl;
  final bool saveImageToHistory;

  const MealDetails({
    super.key,
    this.imagePath,
    required this.saveImageToHistory,
    this.imageUrl,
  });

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  final IsolateUtils _isolateUtils = IsolateUtils();
  late Map<String, Inference> _probabilities = {};
  late Uint8List _image;
  late bool _isLoading;
  late bool _isEnglish;
  bool _showMask = false;
  late HistoryProvider _historyProvider;

  _initialize() async {
    Uint8List imageBytes;

    if (widget.imageUrl != null) {
      final response = await http.get(Uri.parse(widget.imageUrl!));
      imageBytes = response.bodyBytes;
    } else {
      imageBytes = File(widget.imagePath!).readAsBytesSync();
    }

    final interpreter = await Interpreter.fromAsset(
      'assets/model.tflite',
      options: InterpreterOptions()..threads = Platform.numberOfProcessors,
    );

    final labelsData = _isEnglish
        ? await rootBundle.loadString('assets/labels_en.txt')
        : await rootBundle.loadString('assets/labels_uk.txt');
    final labels = labelsData.split('\n');

    await _isolateUtils.start();

    ReceivePort responsePort = ReceivePort();
    final isolateData = IsolateData(
      imageBytes: imageBytes,
      interpreterAddress: interpreter.address,
      labels: labels,
      responsePort: responsePort.sendPort,
    );

    _isolateUtils.sendPort.send(isolateData);
    var (result, image) = await responsePort.first as (
      Map<String, double>,
      img.Image,
    );

    List<int> imageBytesMask = img.encodePng(image);
    _image = Uint8List.fromList(imageBytesMask);

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

    if (widget.saveImageToHistory) {
      if (mounted) {
        debugPrint('Adding scan to history');
        _historyProvider.addScan(context, File(widget.imagePath!));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _historyProvider = Provider.of<HistoryProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _isEnglish = Provider.of<LocaleProvider>(
      context,
      listen: false,
    ).getLocale();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          appLocal.mealDetails,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
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
                      child: widget.imagePath != null
                          ? Image.file(
                              File(widget.imagePath!),
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.imageUrl!,
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
                  '${_showMask ? appLocal.hide : appLocal.show} ${appLocal.foodGroups}',
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
