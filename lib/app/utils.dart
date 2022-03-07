import 'dart:io';
import 'dart:math';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// Pick image from gallery/camera
/// [source] : gallery or camera
/// [crop] : crop image
Future<File?> utilPickImage(ImageSource source, bool crop) async {
  final ImagePicker _picker = ImagePicker();
  XFile? image = await _picker.pickImage(source: source);
  if (image == null) return null;
  if (crop) {
    File? file;
    ImageCropper imageCropper = ImageCropper();

    file = await imageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Cropper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    if (file != null) return file;
  }
  return File(image.path);
}

String uiRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
