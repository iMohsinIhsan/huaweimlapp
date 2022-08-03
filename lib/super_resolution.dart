import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:huawei_ml_image/huawei_ml_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class SuperResolutionPage extends StatefulWidget {
  @override
  State<SuperResolutionPage> createState() => _SuperResolutionPageState();
}

class _SuperResolutionPageState extends State<SuperResolutionPage> {
  Uint8List? _image;

  Future<Uint8List?> huaweiImageSuperResolution() async {
    try {
      final pickedImagePath = await pickImageFromGallery();
      if (pickedImagePath == null) {
        return null;
      }
      // Create an image super resolution analyzer.
      MLImageSuperResolutionAnalyzer analyzer = MLImageSuperResolutionAnalyzer();

// Configure recognition settings.
      final setting = MLImageSuperResolutionAnalyzerSetting.create(path: pickedImagePath);

// Get recognition result asynchronously.
      MLImageSuperResolutionResult result = await analyzer.asyncAnalyseFrame(setting);
      setState(() {
        _image = result.bytes;
      });
      return result.bytes;
// Get recognition result synchronously.
      List<MLImageSuperResolutionResult> results = await analyzer.analyseFrame(setting);

// After the recognition ends, stop analyzer.
      await analyzer.stop();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> pickImageFromGallery() async {
    return (await ImagePicker().pickImage(source: ImageSource.gallery))?.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: huaweiImageSuperResolution,
            child: const Text('Super Resolution'),
          ),
          if (_image != null) Image.memory(_image!),
        ],
      ),
    );
  }
}
