import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:huawei_ml_body/huawei_ml_body.dart';

class MlBodyApi extends StatefulWidget {
  const MlBodyApi({Key? key}) : super(key: key);

  @override
  State<MlBodyApi> createState() => _MlBodyApiState();
}

class _MlBodyApiState extends State<MlBodyApi> {
  final ImagePicker _picker = ImagePicker();
  File? faceDetectionImage;
  List<MLFace>? faceDetectionResult;
  File? faceVerificationImage;
  List<MLSkeleton>? faceVerificationResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Body APIs'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        faceDetectionImage = File(image.path);
                      });
                      final analyzer = MLFaceAnalyzer();

// Configure the recognition settings.
                      final setting =
                          MLFaceAnalyzerSetting(path: faceDetectionImage!.path);

// Get recognition result asynchronously.
                      List<MLFace> faces =
                          await analyzer.asyncAnalyseFrame(setting);

                      setState(() {
                        faceDetectionResult = faces;
                        print('Face Detection Result');
                        print('Face Detection Result');
                        print('Face Detection Result');
                        print(faceDetectionResult!
                            .first.emotions!.smilingProbability);
                        print('Face Detection Result');
                      });

// Get recognition result synchronously.
//                       List<MLFace> faces = await analyzer.analyzeFrame(setting);

// After the recognition ends, stop the analyzer.
                      await analyzer.stop();
                    }
                  },
                  child: Text('Face Detection')),
              faceDetectionImage != null
                  ? Image.file(faceDetectionImage!)
                  : SizedBox(),
              faceDetectionResult != null
                  ? Column(
                      children: [
                        Text(faceDetectionResult!
                            .first.emotions!.smilingProbability
                            .toString()),
                      ],
                    )
                  : Container(),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        faceVerificationImage = File(image.path);
                      });
                      // Create an analyzer for face verification.
                      final analyzer = MLFaceVerificationAnalyzer();

// Create a template face for face verification.
//                       List<MLFaceTemplateResult> templateResult = await analyzer.setTemplateFace(<local image path>, maxFaceNumber);

// Perform face verification based on the template faces asynchronously.
//                       List<MLFaceVerificationResult> results = await analyzer.asyncAnalyseFrame(<local image path>);

// Perform face verification based on the template faces synchronously.
//                       List<MLFaceVerificationResult> results = await analyzer.analyseFrame(<local image path>);

// After verification, stop the analyzer.
                      await analyzer.stop();
                    }
                  },
                  child: Text('Face Verification'))
            ],
          ),
        ),
      ),
    );
  }
}
