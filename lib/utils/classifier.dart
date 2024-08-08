import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'colors.dart';

class Classifier {
  late Interpreter _interpreter;
  final List<String> labels;

  Classifier(int address, this.labels) {
    _interpreter = Interpreter.fromAddress(address);
  }

  (Map<String, double>, img.Image) classify(Uint8List imageBytes) {
    var image = img.decodeImage(imageBytes);

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

    _interpreter.run(imageMatrix, output);

    final segmentation = img.Image(width: 513, height: 513);
    Map<String, double> probabilities = {};

    for (int y = 0; y < 513; y++) {
      for (int x = 0; x < 513; x++) {
        final classes = output[0][y][x];
        double max = -10.0;
        for (int i = 0; i < classes.length; i++) {
          max = classes[i] > max ? classes[i] : max;
        }
        final color = Color(categoryColors[classes.indexOf(max)]);
        segmentation.setPixelRgb(x, y, color.red, color.green, color.blue);

        for (int i = 0; i < labels.length; i++) {
          final label = labels[i];
          final probability = output[0][y][x][i];
          probabilities[label] = (probabilities[label] ?? 0) + probability;
        }
      }
    }

    final sum = probabilities.values.reduce((a, b) => a + b);
    probabilities = probabilities.map(
      (key, value) => MapEntry(
        key,
        (value / sum),
      ),
    );

    return (probabilities, segmentation);
  }
}
