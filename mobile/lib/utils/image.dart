import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

img.Image yuv420ToRgb(CameraImage image) {
  final int width = image.width;
  final int height = image.height;

  var imgRgb = img.Image(width: width, height: height);

  final planes = image.planes;
  final int uvRowStride = planes[1].bytesPerRow;
  final int uvPixelStride = planes[1].bytesPerPixel!;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int uvIndex = uvRowStride * (y ~/ 2) + (x ~/ 2) * uvPixelStride;
      final int index = y * width + x;

      final yp = planes[0].bytes[index];
      final up = planes[1].bytes[uvIndex];
      final vp = planes[2].bytes[uvIndex];

      // Convert YUV to RGB
      var r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      var g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      var b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

      imgRgb.setPixelRgb(x, y, r, g, b);
    }
  }

  return imgRgb;
}

img.Image nv21ToRgb(CameraImage image) {
  final int width = image.width;
  final int height = image.height;

  var imgRgb = img.Image(width: width, height: height);

  final Uint8List yPlane = image.planes[0].bytes;
  final Uint8List vuPlane = image.planes[1].bytes;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int yIndex = y * width + x;
      final int vuIndex = (y ~/ 2) * width + (x ~/ 2) * 2;

      final int yp = yPlane[yIndex];
      final int vp = vuPlane[vuIndex];
      final int up = vuPlane[vuIndex + 1];

      var r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      var g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      var b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

      imgRgb.setPixelRgb(x, y, r, g, b);
    }
  }

  return imgRgb;
}
