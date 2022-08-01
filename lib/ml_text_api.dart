import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:huawei_ml_text/huawei_ml_text.dart';
import 'package:huaweimlapp/main.dart';
import 'package:image_picker/image_picker.dart';

class MlTextApi extends StatefulWidget {
  const MlTextApi({Key? key}) : super(key: key);

  @override
  State<MlTextApi> createState() => _MlTextApiState();
}

class _MlTextApiState extends State<MlTextApi> {
  late CameraController cameraController;
  final ImagePicker _picker = ImagePicker();
  File? galleryTextImage;
  File? cameraTextImage;
  File? galleryDocumentImage;
  File? bankCardImage;
  File? formImage;
  String? galleryImageText;
  String? cameraImageText;
  bool cameraSwitch = false;
  String? documentText;
  int? textureId;
  final textLensController = MLTextLensController(
      // Set the transaction type
      transaction: TextTransaction.text,
      // Set the lens to front or back
      lensType: MLTextLensController.backLens);
  MLTextLensEngine? engine;
  MLBankcard? bankCard;
  MLFormRecognitionTablesAttribute? formTable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
    setApiKey();
  }

  Future<void> setApiKey() async {
    MLTextApplication().setApiKey(
        "DAEDACsUCq0Dmt1rjZ8RR13TRUxirBg7wHe7dhVNeL9WO1rzKIHtmMnZfBJGuW1U3depyH3JCa9I29NRKGIPUtjSiZIpw+gGXTuBCw==");
  }

  void setupTransactions() {
    void onTransaction({dynamic result}) {}
    engine!.setTransactor(onTransaction);
    initializeTexture();
  }

  Future<void> initializeTexture() async {
    await engine!.init().then((value) {
      setState(() => textureId = value);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    // engine!.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Text APIs'),
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
                  final XFile? imagePicked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    galleryTextImage = File(imagePicked!.path);
                  });
                  MLTextAnalyzer analyzer = MLTextAnalyzer();
                  MLTextAnalyzerSetting setting = MLTextAnalyzerSetting.remote(
                      path: galleryTextImage!.path);
                  setting.isRemote = true;
                  setting.language = "en";
                  // List<TextBlock> list = await analyzer.analyseFrame(setting);
                  MLText text = await analyzer.asyncAnalyseFrame(setting);
                  setState(() {
                    // galleryImageText = list[0].stringValue;
                    galleryImageText = text.stringValue;
                    print(galleryImageText);
                  });
                  await analyzer.stop();
                },
                child: const Text('Text Recognition Gallery'),
              ),
              galleryTextImage == null
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .2,
                      child: Image.file(galleryTextImage!),
                    ),
              galleryImageText == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(galleryImageText ?? ''),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? imagePicked =
                      await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    cameraTextImage = File(imagePicked!.path);
                  });
                  MLTextAnalyzer analyzer = MLTextAnalyzer();
                  MLTextAnalyzerSetting setting =
                      MLTextAnalyzerSetting.local(path: cameraTextImage!.path);
                  setting.isRemote = true;
                  setting.language = "en";
                  List<TextBlock> list = await analyzer.analyseFrame(setting);
                  setState(() {
                    cameraImageText = list[0].stringValue;
                  });
                  await analyzer.stop();
                },
                child: const Text('Text Recognition Camera'),
              ),
              cameraTextImage == null
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .2,
                      child: Image.file(cameraTextImage!),
                    ),
              cameraImageText == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(cameraImageText ?? ''),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    cameraSwitch = !cameraSwitch;
                  });
                  engine = MLTextLensEngine(controller: textLensController);
                  setupTransactions();
                },
                child: const Text('Camera Stream'),
              ),
              cameraSwitch
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: !cameraController.value.isInitialized
                          ? Container()
                          : CameraPreview(cameraController),
                    )
                  : const SizedBox(),

              // MLTextLens(
              //   textureId: textureId,
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   height: MediaQuery.of(context).size.height * 0.3,
              // ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? imagePicked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    galleryDocumentImage = File(imagePicked!.path);
                  });
                  MLDocumentAnalyzer analyzer = MLDocumentAnalyzer();
                  MLDocumentAnalyzerSetting setting =
                      MLDocumentAnalyzerSetting.create(
                          path: galleryDocumentImage!.path);
                  MLDocument mlDocument =
                      await analyzer.asyncAnalyzeFrame(setting);
                  setState(() {
                    documentText = mlDocument.stringValue;
                  });
                },
                child: const Text('Document Recognition'),
              ),
              const SizedBox(
                height: 20,
              ),
              galleryDocumentImage == null
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .2,
                      child: Image.file(galleryDocumentImage!),
                    ),
              documentText == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(documentText ?? ''),
                      ),
                    ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? imagePicked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    bankCardImage = File(imagePicked!.path);
                  });

                  MLBankcardAnalyzer analyzer = MLBankcardAnalyzer();

                  MlBankcardSettings settings =
                      MlBankcardSettings.image(path: bankCardImage!.path);

                  settings.orientation = MlBankcardSettings.orientationAuto;
                  settings.resultType = MlBankcardSettings.resultAll;
                  settings.path = bankCardImage!.path;
                  MLBankcard card = await analyzer.analyseFrame(settings);

                  setState(() {
                    bankCard = card;
                  });
                },
                child: const Text('Bank Card Recognition'),
              ),

              bankCardImage == null
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .2,
                      child: Image.file(bankCardImage!),
                    ),

              bankCard == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Card Issuer: ${bankCard!.issuer}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Card Number: ${bankCard!.number}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Expiry Date: ${bankCard!.expire}"),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? imagePicked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    formImage = File(imagePicked!.path);
                  });

                  // Create an MLFormRecognitionAnalyzer object.
                  MLFormRecognitionAnalyzer analyzer =
                      MLFormRecognitionAnalyzer();

// Call asyncFormDetection to recognize text asynchronously.
//                     MLFormRecognitionTablesAttribute table = await analyzer.asyncAnalyseFrame("local image path");

// Call syncFormDetection to recognize text synchronously.
                  MLFormRecognitionTablesAttribute table =
                      await analyzer.analyseFrame(formImage!.path);
                  setState(() {
                    formTable = table;
                    print('FORM TABLE DATA');
                    print('FORM TABLE DATA');
                    print('FORM TABLE DATA');
                    print('FORM TABLE DATA');
                    print(formTable);
                  });

// After the recognition ends, stop the analyzer.
                  bool result = await analyzer.stop();
                },
                child: const Text('Form Recognition'),
              ),
              formImage == null
                  ? const SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .2,
                      child: Image.file(formImage!),
                    ),
              formTable == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: List.generate(
                              formTable!.tablesContent!.tableAttributes.length,
                              (index) {
                            return Text(getData(formTable!
                                .tablesContent!.tableAttributes[index]!));
                          }),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getData(TableAttribute tableAttributes) {
    return tableAttributes.tableCellAttributes
        .map((e) => e!.textInfo!)
        .reduce((value, element) => "$value \n $element\n");
  }
}
