import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picture_taker/flutter_picture_taker.dart';
import 'package:gap/gap.dart';

void main() => runApp(const MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _image;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        body: Center(
          child: Column(
            children: [
              OutlinedButton(
                onPressed: _takePicture,
                child: const Text('Take picture'),
              ),
              const Gap(8),
              Text(_image?.path ?? 'No image'),
              const Gap(8),
              if (_image != null)
                kIsWeb
                    ? Image.network(_image!.path)
                    : Image.file(File(_image!.path)),
            ],
          ),
        ),
      );

  Future<void> _takePicture() async {
    final image = await showStillCameraDialog(context);
    if (image != null) setState(() => _image = image);
  }
}
