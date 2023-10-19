import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'accept_image.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  late CameraController _controller;
  bool _isInitialized = false;

  Future<void> _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();

    _initCameraController(cameras.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _controller;

    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraController(cameraController.description);
    }
  }

  Future<void> _initCameraController(
      CameraDescription cameraDescription) async {
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
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

    _controller.setFlashMode(FlashMode.off);
    _controller.takePicture().then((image) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcceptImage(selectedImage: image.path),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
              child: SizedBox(
                width: w,
                child: CameraPreview(_controller),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.all(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: _takePhoto,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    size: 40,
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
