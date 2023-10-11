import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassifier {
  late Interpreter interpreter;
  late List<String> labels;

  final String _labelsFileName = 'assets/labels.txt';
  final String _modelFileName = 'assets/model.tflite';

  ImageClassifier() {
    loadLabels();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(_modelFileName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  Future<void> loadLabels() async {
    final labelsData = await rootBundle.loadString(_labelsFileName);
    labels = labelsData.split('\n');
  }

  Future<Map<String, double>> processImage(String imagePath) async {
    final imageData = File(imagePath).readAsBytesSync();
    var image = img.decodeImage(imageData);

    final imageInput = img.copyResize(
      image!,
      width: 513,
      height: 513,
    );

    // Get image matrix representation [513, 513, 3]
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );

    // [1, 513, 513, 26]
    final output = List.generate(1, (i) {
      return List.generate(513, (j) {
        return List.generate(513, (k) {
          return List<double>.filled(26, 0.0);
        });
      });
    });

    interpreter.run(imageMatrix, output);

    final Map<String, double> probabilities = {};

    for (int y = 0; y < 513; y++) {
      for (int x = 0; x < 513; x++) {
        for (int i = 0; i < labels.length; i++) {
          final label = labels[i];
          final probability = output[0][y][x][i];
          probabilities[label] = (probabilities[label] ?? 0) + probability;
        }
      }
    }

    return probabilities;
  }

  void close() {
    interpreter.close();
  }
}
