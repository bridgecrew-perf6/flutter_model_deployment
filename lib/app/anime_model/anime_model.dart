import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nn_model_deployment/app/utils.dart';
import 'package:nn_model_deployment/image/image_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class AnimeModelView extends StatefulWidget {
  const AnimeModelView({Key? key}) : super(key: key);

  @override
  State<AnimeModelView> createState() => _AnimeModelViewState();
}

class _AnimeModelViewState extends State<AnimeModelView> {
  File? _file;
  File? _file2;
  img.Image? _image;
  List<dynamic>? _imageValues;
  Interpreter? _interpreter;

  @override
  void initState() {
    _loadModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Test'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
              child: (_file != null)
                  ? Image.file(
                      _file!,
                      fit: BoxFit.fitHeight,
                    )
                  : const Center(child: Text('input image')),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              _selectImage();
            },
            child: const Text(
              'Pick image',
            ),
          ),
          Expanded(
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
              child: (_file2 != null)
                  ? Image.file(
                      _file2!,
                      fit: BoxFit.fitHeight,
                    )
                  : const Center(child: Text('Output image')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectImage() async {
    _file = await utilPickImage(ImageSource.gallery, true);

    if (_file == null) return;

    _image = img.decodeImage(_file!.readAsBytesSync());
    _image = img.copyResize(_image!, width: 256, height: 256);
    _imageValues = _image!.toListDouble();

    _file2 = await predict(_imageValues!);
    setState(() {});
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('selfie2anime.tflite');
  }

  Future<File> predict(List<dynamic> rgbValues) async {
    var output = List.filled(256 * 256 * 3, 0).reshape([rgbValues].shape);

    _interpreter!.run([rgbValues], output);

    img.Image image = img.Image.from(_image!);

    for (var i = 0; i < 256; i++) {
      for (var j = 0; j < 256; j++) {
        for (var k = 0; k < 3; k++) {
          image.setPixelRgba(
            i,
            j,
            (output[0][j][i][0] * 256).round(),
            (output[0][j][i][1] * 256).round(),
            (output[0][j][i][2] * 256).round(),
          );
        }
      }
    }

    Directory tempDir = await getTemporaryDirectory();
    final File file = File("${tempDir.path}/${uiRandomString(50)}.png");

    return await file.writeAsBytes(img.encodePng(image));
  }
}
