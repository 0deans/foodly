import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:foodly/widgets/icon_circle_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'accept_image.dart';
import 'package:image/image.dart' as img;
import 'package:foodly/utils/image.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  late CameraController _controller;
  bool _isInitialized = false;
  bool _isCameraAccessDenied = false;
  bool _isFlash = false;

  Future<void> _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();

    _initCameraController(cameras.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraController(_controller.description);
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
    }).catchError((error) {
      if (error is CameraException) {
        if (error.code == 'CameraAccessDenied') {
          setState(() {
            _isCameraAccessDenied = true;
          });
        }
      }
    });
  }

  Future<void> _takePhoto() async {
    if (!_controller.value.isInitialized) return;

    XFile? image;

    if (Platform.isAndroid) {
      image = await _takePictureAndroid12();
    } else {
      image = await _controller.takePicture();
    }

    var xFile = image;
    if (xFile != null) {
      _controller.pausePreview();
      setState(() {
        _controller.setFlashMode(FlashMode.off);
        _isFlash = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcceptImage(selectedImage: xFile),
        ),
      ).then((_) => _controller.resumePreview());
    }
  }

  Future<XFile?> _takePictureAndroid12() async {
    // Ensure the image stream is not already running
    if (_controller.value.isStreamingImages == true) {
      await _controller.stopImageStream();
    }

    // Create a completer to wait for the image processing to complete
    final completer = Completer<img.Image?>();

    await _controller.startImageStream((cameraImage) async {
      // Stop the image stream after receiving the image
      await _controller.stopImageStream();

      // Process the image
      final img.Image image = switch (cameraImage.format.group) {
        ImageFormatGroup.nv21 => nv21ToRgb(cameraImage), // custom function
        ImageFormatGroup.jpeg => img.decodeImage(cameraImage.planes[0].bytes)!,
        _ => yuv420ToRgb(cameraImage), // custom function
      };

      // Rotate the image based on sensor orientation
      final img.Image rotated = img.copyRotate(
        image,
        angle: _controller.description.sensorOrientation,
      );

      print('Image captured ${rotated}');

      // Complete the completer with the rotated image
      completer.complete(rotated);
    });

    // Wait for the image processing to finish
    final rotatedImg = await completer.future;

    if (rotatedImg == null) {
      print('Error: Image not captured');
      return null;
    }

    // Save the image data to a temporary file
    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';

    // Write the bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(img.encodePng(rotatedImg));

    // Return the XFile created from the file
    return XFile(filePath);
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

    final appLocal = AppLocalizations.of(context)!;

    if (_isCameraAccessDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appLocal.cameraPermissionError,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
              child: ElevatedButton(
                onPressed: () async {
                  final status = await Permission.camera.request();
                  if (status == PermissionStatus.granted) {
                    setState(() {
                      _isCameraAccessDenied = false;
                      _initCamera();
                    });
                  } else {
                    openAppSettings().then((_) {
                      Navigator.pop(context);
                    });
                  }
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(
                  appLocal.grantAccess,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconCircleButton(
                    iconSize: 20,
                    iconData: _isFlash ? Icons.flash_on : Icons.flash_off,
                    onTap: () {
                      setState(() {
                        _isFlash = !_isFlash;
                      });
                      _controller.setFlashMode(
                          _isFlash ? FlashMode.torch : FlashMode.off);
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 40,
                  ),
                  child: IconCircleButton(
                    iconSize: 30,
                    iconData: Icons.photo_camera,
                    onTap: _takePhoto,
                  ),
                ),
                const SizedBox(
                  width: 40,
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
