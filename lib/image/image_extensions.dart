import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

extension ImageUtils on img.Image {
  List<dynamic> toListDouble() {
    final List<dynamic> rgbList =
        List.filled(height * width * 3, 0.0).reshape([width, height, 3]);
    late double r, g, b;
    for (var i = 0; i < width; i++) {
      for (var j = 0; j < height; j++) {
        r = (getPixelSafe(j, i) >> 0 & 0x000000FF).toDouble();
        g = (getPixelSafe(j, i) >> 8 & 0x000000FF).toDouble();
        b = (getPixelSafe(j, i) >> 16 & 0x000000FF).toDouble();
        rgbList[i][j] = [r, g, b];
      }
    }
    return rgbList;
  }
}
