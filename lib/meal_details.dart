import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodly/isolate_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MealDetails extends StatefulWidget {
  final String imagePath;

  const MealDetails({super.key, required this.imagePath});

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  final IsolateUtils _isolateUtils = IsolateUtils();
  late Map<String, double> _probabilities;
  late bool _isLoading;

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
    var result = await responsePort.first as Map<String, double>;

    interpreter.close();
    _isolateUtils.dispose();

    final sum = result.values.reduce((a, b) => a + b);
    result = result.map((key, value) => MapEntry(key, (value / sum)));

    _probabilities = Map.fromEntries(
      result.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)),
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
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
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
                  final probability = _probabilities[className];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        className.capitalize(),
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        '${(probability! * 100).toStringAsFixed(2)}%',
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
