import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassifier {
  late Interpreter interpreter;
  late List<String> labels;

  final String _labelsPath = 'assets/labels.txt';
  final String _modelPath = 'assets/model.tflite';

  Future<void> loadModel() async {
    final interpreterOptions = InterpreterOptions();
    interpreterOptions.threads = 4;
    interpreter = await Interpreter.fromAsset(
      _modelPath,
      options: InterpreterOptions()..threads = 4,
    );
  }

  Future<void> loadLabels() async {
    final labelsData = await rootBundle.loadString(_labelsPath);
    labels = labelsData.split('\n');
    print('initLabels');
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

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(imageMatrix, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference: $run ms');
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
