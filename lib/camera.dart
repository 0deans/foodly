import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'acceptImageForScan.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  bool _isInitialized = false;

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isInitialized = true;
      });
    });
  }

  Future<void> _takePhoto() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    _controller.takePicture().then((image) {
      if (image != null) {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => AcceptImage(selectedImage: image.path)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SizedBox(
        height: h,
        width: w,
        child: Column(
          children: [
            Expanded(
                child: Container(
              width: w,
              padding: const EdgeInsets.only(top: 25),
              child: CameraPreview(_controller),
            )),
            Container(
                height: 80,
                width: 80,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: _takePhoto,
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(200, 255, 0, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    child: Center(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ))))
          ],
        ),
      ),
    );
  }
}
