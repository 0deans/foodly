import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        camera: camera,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller;
  XFile? _imageFile;

  Interpreter? _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
  }

  Future<void> processImage() async {
    try {
      final imageData = File(_imageFile!.path).readAsBytesSync();

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


      // Create an output tensor with the correct shape [1, 513, 513, 26]
      final output = List.generate(1, (i) {
        return List.generate(513, (j) {
          return List.generate(513, (k) {
            return List<double>.filled(26, 0.0);
          });
        });
      });

      _interpreter!.run(imageMatrix, output);

      final labelsData = await rootBundle.loadString('assets/labels.txt');
      final lines = labelsData.split('\n');

      final List<String> classLabels = [];

      for (int i = 0; i < lines.length; i++) {
        final label = lines[i];
        classLabels.add(label);
      }

      final Map<String, double> classProbabilities = {};

      for (final label in classLabels) {
        classProbabilities[label] = 0.0;
      }

      for (int y = 0; y < 513; y++) {
        for (int x = 0; x < 513; x++) {
          for (int i = 0; i < classLabels.length; i++) {
            final label = classLabels[i];
            final prob = output[0][y][x][i];
            classProbabilities[label] = (classProbabilities[label] ?? 0) + prob;
          }
        }
      }

      double sum = 0;

      classProbabilities.forEach((key, value) {
        sum += value;
      });

      classProbabilities.forEach((key, value) {
        final cleanedKey = key.trim();
        final x = value / sum;
        print([cleanedKey, x]);
      });

      print(sum);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    loadModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    _interpreter!.close();
    super.dispose();
  }

  void _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      final XFile image = await _controller.takePicture();
      setState(() {
        _imageFile = image;
      });
      await GallerySaver.saveImage(image.path);
      processImage();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(_controller)),
        Positioned(
          left: 0,
          right: 0,
          bottom: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 64,
                height: 64,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('take a picture'),
                ),
              ),
              ClipOval(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: _imageFile != null
                      ? Center(
                          child: Transform.scale(
                            scale: 2.0,
                            child: Image.file(File(_imageFile!.path)),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
