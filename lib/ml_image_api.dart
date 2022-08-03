import 'dart:io';

import 'package:flutter/material.dart';
import 'package:huawei_ml_image/huawei_ml_image.dart';
import 'package:image_picker/image_picker.dart';

class MlImageApi extends StatefulWidget {
  const MlImageApi({Key? key}) : super(key: key);

  @override
  State<MlImageApi> createState() => _MlImageApiState();
}

class _MlImageApiState extends State<MlImageApi> {
  final ImagePicker _picker = ImagePicker();
  File? classificationImage;
  List<MLImageClassification>? imageClassificationList;
  File? objectDetectionImage;
  List<MLObject>? objectDetectionList;
  List<String> objectDetectionCategories = [
    'Others',
    'GOODS',
    'FOOD',
    'FURNITURE',
    'PLANT',
    'PLACE',
    'FACE'
  ];
  File? landmarkRecognitionImage;
  File? segmentationImage;
  List<MLRemoteLandmark>? landmarkRecognitionList;
  List<MLImageSegmentation>? segmentationList;
  File? backgroundImage;
  File? superResolutionImage;
  File? visualSearchImage;
  File? skewCorrectionImage;
  MLDocumentSkewCorrectionResult? correctedImageResult;
  MLImageSuperResolutionResult? superResolutionResult;
  File? textSuperResolutionImage;
  MLTextImageSuperResolution? textSuperResolutionResult;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setApiKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Image APIs'),
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
                        classificationImage = File(image.path);
                      });

                      MLImageClassificationAnalyzer analyzer =
                          MLImageClassificationAnalyzer();
                      final setting = MLClassificationAnalyzerSetting.create(
                          path: classificationImage!.path, isRemote: false);
                      List<MLImageClassification> list =
                          await analyzer.analyseFrame(setting);
                      print('Image Classification');
                      print('Image Classification');
                      print(list.length);
                      for (var element in list) {
                        print("${element.name}");
                      }
                      if (list.isNotEmpty) {
                        setState(() {
                          imageClassificationList = list;
                        });
                      }

                      print('Image Classification');
                      print('Image Classification');
                    }
                  },
                  child: const Text('Image Classification')),
              classificationImage != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.file(classificationImage!),
                    )
                  : const SizedBox(),
              imageClassificationList != null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Category Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: imageClassificationList!
                                        .map((e) => Text(e.name!))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Possibility',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: imageClassificationList!
                                        .map((e) => Text((e.possibility! * 100)
                                            .toStringAsFixed(2)))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      objectDetectionImage = File(image.path);
                    });

                    MLObjectAnalyzer analyzer = MLObjectAnalyzer();

// Configure the recognition settings.
                    final setting = MLObjectAnalyzerSetting.create(
                        path: objectDetectionImage!.path);

// Get object recognition result asynchronously.
//                     List<MLObject> list = await analyzer.asyncAnalyseFrame(setting);

// Get object recognition result synchronously.
                    List<MLObject> list = await analyzer.analyseFrame(setting);

                    // After the recognition ends, stop analyzer.
                    // await analyzer.stop();

                    print('Object Detection');
                    print(list.length);
                    for (var element in list) {
                      print("${element.type}");
                      print("${element.possibility}");
                    }
                    if (list.isNotEmpty) {
                      setState(() {
                        objectDetectionList = list;
                      });
                    }

                    print('Object Detection');
                  }
                },
                child: const Text('Object Detection'),
              ),
              objectDetectionImage != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.file(objectDetectionImage!),
                    )
                  : const SizedBox(),
              objectDetectionList != null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Object Category',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: objectDetectionList!
                                        .map((e) => Text(
                                            "${objectDetectionCategories[e.type!]}"))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Possibility',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: objectDetectionList != null
                                        ? objectDetectionList!
                                            .map((e) => e.possibility != null
                                                ? Text((e.possibility * 100)
                                                    .toStringAsFixed(2))
                                                : const Text('unknown'))
                                            .toList()
                                        : [],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        landmarkRecognitionImage = File(image.path);
                      });

                      MLLandmarkAnalyzer analyzer = MLLandmarkAnalyzer();

                      final setting = MLLandmarkAnalyzerSetting.create(
                          path: landmarkRecognitionImage!.path);

                      List<MLRemoteLandmark> list =
                          await analyzer.asyncAnalyseFrame(setting);

                      print('Landmark Recognition Result');
                      print("List length ${list.length}");
                      print(list.elementAt(0).positionInfos.map((e) => e!.lat));
                      print(list.elementAt(0).positionInfos.map((e) => e!.lng));
                      print(list.elementAt(0).landmark);
                      print('Landmark Recognition Result');
                      setState(() {
                        landmarkRecognitionList = list;
                      });

                      await analyzer.stopLandmarkDetection();
                    }
                  },
                  child: const Text('Landmark Recognition')),
              landmarkRecognitionImage != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.file(landmarkRecognitionImage!),
                    )
                  : const SizedBox(),
              landmarkRecognitionList != null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(children: [
                        ...landmarkRecognitionList!
                            .map((e) => Text("Landmark Name: ${e.landmark!}"))
                            .toList(),
                        ...landmarkRecognitionList!
                            .map((e) => Text(
                                "Latitude: ${e.positionInfos.map((e) => e!.lat)}"))
                            .toList(),
                        ...landmarkRecognitionList!
                            .map((e) => Text(
                                "Longitude: ${e.positionInfos.map((e) => e!.lng)}"))
                            .toList(),
                      ]),
                    )
                  : const SizedBox(),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        backgroundImage = File(image.path);
                      });
                    }
                  },
                  child: const Text('Pick Background Image')),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        segmentationImage = File(image.path);
                      });

                      MLImageSegmentationAnalyzer analyzer =
                          MLImageSegmentationAnalyzer();

// Configure the recognition settings.
                      final setting = MLImageSegmentationAnalyzerSetting.create(
                        path: segmentationImage!.path,
                        analyzerType:
                            MLImageSegmentationAnalyzerSetting.BODY_SEG,
                      );
// Get segmentation result asynchronously.
//                       MLImageSegmentation segmentation = await analyzer.asyncAnalyseFrame(setting);

// Get segmentation results synchronously.
                      List<MLImageSegmentation> segmentations =
                          await analyzer.analyseFrame(setting);

                      setState(() {
                        segmentationList = segmentations;
                        print('SEGMENTATION');
                        print(segmentationList!.first.grayscale!);
                        print('SEGMENTATION');
                      });

// After the recognition ends, stop analyzer.
                      await analyzer.stop();
                    }
                  },
                  child: const Text('Image Segmentation')),
              segmentationImage != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.file(segmentationImage!),
                    )
                  : const SizedBox(),
              segmentationList != null
                  ? Column(
                      children: [
                        Image.memory(segmentationList![0].foreground!),
                        // Image.memory(segmentationList![0].grayscale!),
                        // Image.memory(segmentationList![0].masks!),
                        // Image.memory(segmentationList![0].original!),
                      ],
                    )
                  : Container(),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        superResolutionImage = File(image.path);
                      });

                      MLImageSuperResolutionAnalyzer analyzer =
                          MLImageSuperResolutionAnalyzer();

// Configure recognition settings.
                      final setting =
                          MLImageSuperResolutionAnalyzerSetting.create(
                              path: superResolutionImage!.path);

// Get recognition result asynchronously.
                      MLImageSuperResolutionResult result =
                          await analyzer.asyncAnalyseFrame(setting);

// Get recognition result synchronously.
//                       List<MLImageSuperResolutionResult> results =
//                           await analyzer.analyseFrame(setting);

                      setState(() {
                        superResolutionResult = result;
                      });
// After the recognition ends, stop analyzer.
                      await analyzer.stop();
                    }
                  },
                  child: Text('Image Super Resolution')),
              superResolutionImage != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.file(superResolutionImage!),
                    )
                  : const SizedBox(),
              superResolutionResult != null
                  ? Image.memory(superResolutionResult!.bytes!)
                  : Container(),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        visualSearchImage = File(image.path);
                      });

                      // Create a product analyzer.
                      MLProductVisionSearchAnalyzer analyzer =
                          MLProductVisionSearchAnalyzer();

// Configure the recognition settings.
                      final setting =
                          MLProductVisionSearchAnalyzerSetting.local(
                        path: visualSearchImage!.path,
                        productSetId: 'phone',
                      );

// Get the search results.
                      List<MlProductVisualSearch?> visionSearch =
                          await analyzer.searchProduct(setting);
                      print('VISUAL SEARCH');
                      print('VISUAL SEARCH');
                      print(visionSearch.length);
                      print('VISUAL SEARCH');

// After the recognition ends, stop analyzer.
                      bool result = await analyzer.stopProductAnalyzer();
                    }
                  },
                  child: const Text('Product Visual Serach')),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        skewCorrectionImage = File(image.path);
                      });
                      MLDocumentSkewCorrectionAnalyzer analyzer =
                          MLDocumentSkewCorrectionAnalyzer();

                      MLDocumentSkewDetectResult detectionResult =
                          await analyzer
                              .analyseFrame(skewCorrectionImage!.path);

                      MLDocumentSkewCorrectionResult corrected =
                          await analyzer.syncDocumentSkewCorrect();
                      setState(() {
                        correctedImageResult = corrected;
                      });
                      await analyzer.stop();
                    }
                  },
                  child: const Text('Document Skew Correction')),
              skewCorrectionImage != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.file(skewCorrectionImage!),
                    )
                  : const SizedBox(),
              correctedImageResult != null
                  ? Image.memory(correctedImageResult!.bytes!)
                  : Container(),
              ElevatedButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        textSuperResolutionImage = File(image.path);
                      });

                      // Create a text image super resolution analyzer.
                      MLTextImageSuperResolutionAnalyzer analyzer =
                          MLTextImageSuperResolutionAnalyzer();

// Get recognition result asynchronously.
                      MLTextImageSuperResolution result =
                          await analyzer.asyncAnalyseFrame("local image path");

                      setState(() {
                        textSuperResolutionResult = result;
                      });
// Get recognition result synchronously.
//                       List<MLTextImageSuperResolution> list = await analyzer.analyseFrame("local image path");

// After the recognition ends, stop the analyzer.
                      bool res = await analyzer.stop();
                    }
                  },
                  child: Text('Text Image Super Resolution')),
              textSuperResolutionImage != null
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.file(textSuperResolutionImage!),
                    )
                  : SizedBox(),
              textSuperResolutionResult != null
                  ? Image.memory(textSuperResolutionResult!.bytes!)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setApiKey() async {
    MLImageApplication().setApiKey(
        "DAEDACsUCq0Dmt1rjZ8RR13TRUxirBg7wHe7dhVNeL9WO1rzKIHtmMnZfBJGuW1U3depyH3JCa9I29NRKGIPUtjSiZIpw+gGXTuBCw==");
  }
}
