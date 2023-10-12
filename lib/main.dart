import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'ImageClassifier.dart';
import 'TestPage.dart';

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
  late ImageClassifier _imageClassifier;
  XFile? _imageFile;

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

    _imageClassifier = ImageClassifier();
  }

  @override
  void dispose() {
    _controller.dispose();
    _imageClassifier.close();
    super.dispose();
  }

  Future<Map<String, double>?> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    try {
      final XFile image = await _controller.takePicture();
      setState(() {
        _imageFile = image;
      });
      await GallerySaver.saveImage(image.path);

      final probabilities = await _imageClassifier.processImage(image.path);

      return probabilities;

      final sum = probabilities.values.reduce((a, b) => a + b);

      probabilities.forEach((key, value) {
        String percentage = '${(value / sum).toStringAsFixed(2)}%';
        print([key.trim(), percentage]);
      });
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
                  onPressed: () {
                    _takePicture().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPage(probabilities: value),
                        ),
                      );
                    });
                  },
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
