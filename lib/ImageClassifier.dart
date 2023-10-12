import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' as x;
import 'package:gallery_saver/gallery_saver.dart';
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
    final labelsData = await x.rootBundle.loadString(_labelsFileName);
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

    //

    try {
      final segmentation  = img.Image(width: 513, height: 513);

      for (int y = 0; y < 513; y++) {
        for (int x = 0; x < 513; x++) {
          final classes = output[0][y][x];
          double max = -10.0;
          for (int i = 0; i < classes.length; i++) {
            max = classes[i] > max ? classes[i] : max;
          }
          final color = generateUniqueColor(classes.indexOf(max));
          segmentation.setPixelRgb(x, y, color.red, color.green, color.blue);
        }
      }

      final tempDir = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/$timestamp.png');

      List<int> pngBytes = img.encodePng(segmentation);
      tempFile.writeAsBytesSync(pngBytes);

      GallerySaver.saveImage(tempFile.path, albumName: 'test');
    } catch (e) {
      print("Fucking error: ${e.toString()}");
    }

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

  Color generateUniqueColor(int classIndex) {
    int totalClasses = 26; // Assuming there are 26 different classes (0 to 25).
    double hue = (classIndex / totalClasses) * 360.0;
    int red = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor().red;
    int green = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor().green;
    int blue = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor().blue;
    return Color.fromARGB(255, red, green, blue);
  }

  void close() {
    interpreter.close();
  }
}
