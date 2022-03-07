import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class XorModelView extends StatefulWidget {
  const XorModelView({Key? key}) : super(key: key);

  @override
  State<XorModelView> createState() => _XorModelViewState();
}

class _XorModelViewState extends State<XorModelView> {
  tfl.Interpreter? _interpreter;
  final List<dynamic> _input = [
    [0.0, 0.0],
    [0.0, 1.0],
    [1.0, 0.0],
    [1.0, 1.0]
  ];
  List<dynamic>? _output;

  @override
  void initState() {
    _loadModel();
    super.initState();
  }

  Future<void> _loadModel() async {
    _interpreter = await tfl.Interpreter.fromAsset('xor.tflite');
    _run();
  }

  void _run() {
    _output = List.filled(4, 0).reshape([4, 1]);

    setState(() {
      _interpreter!.run(_input, _output!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NN Test'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: _output != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _input.length,
                  (index) => Text(
                      "${_input[index][0]}   XOR   ${_input[index][1]}  =   ${_output![index][0].round()}"),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
