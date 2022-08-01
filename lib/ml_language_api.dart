import 'package:flutter/material.dart';
import 'package:huawei_ml_text/huawei_ml_text.dart';
import 'package:huawei_ml_language/huawei_ml_language.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';

class MlLanguageApi extends StatefulWidget {
  const MlLanguageApi({Key? key}) : super(key: key);

  @override
  State<MlLanguageApi> createState() => _MlLanguageApiState();
}

class _MlLanguageApiState extends State<MlLanguageApi> {
  String? translatedText;
  String? detectedLanguage;
  String? textToDetectLanguage;
  String? textToTranslate;
  String? textToSpeech;
  String? asrText;
  String? transcriptedAudioText;
  PlatformFile? file;
  final player = AudioPlayer();
  final textLensController = MLTextLensController(
      transaction: TextTransaction.text,
      lensType: MLTextLensController.backLens);
  MLTextLensEngine? engine;
  Image? image;
  MLBankcard? bankCard;
  MLFormRecognitionTablesAttribute? formTable;

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
        title: const Text('ML Language APIs'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                initialValue: "Ali brushes his teeth twice a day",
                onChanged: (value) {
                  textToTranslate = value;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  // Create an MLRemoteTranslator object.
                  MLRemoteTranslator translator = MLRemoteTranslator();

// Create an MLTranslateSetting object to configure translation.
                  final setting = MLTranslateSetting.remote(
                      sourceText: textToTranslate != null
                          ? textToTranslate!
                          : "Ali brushes his teeth twice a day",
                      sourceLangCode: "en",
                      targetLangCode: "ur");

// Get the translation result asynchronously.
//                   String? result = await translator.asyncTranslate(setting);

// Get the translation result synchronously.
                  String? result = await translator.syncTranslate(setting);

                  setState(() {
                    translatedText = result;
                  });

// Stop translator after the translation ends.
//                   await translator.stopTranslate();

                  // // Create an MLLocalTranslator object.
                  // MLLocalTranslator localTranslator = MLLocalTranslator();
                  //
                  // void downloadListener({all, downloaded}) {}
                  // localTranslator.setDownloadListener(downloadListener);
                  //
                  // final strategy = LanguageModelDownloadStrategy();
                  // strategy.needWifi();
                  //
                  // final setting = MLTranslateSetting.local(
                  //   sourceLangCode: "en",
                  //   targetLangCode: "hi",
                  // );
                  //
                  // final prepared =
                  //     await localTranslator.prepareModel(setting, strategy);
                  // if (prepared) {
                  //   String? res = await localTranslator.asyncTranslate(
                  //       textToTranslate != null
                  //           ? textToTranslate!
                  //           : "Ali brushes his teeth twice a day");
                  //   setState(() {
                  //     translatedText = res;
                  //   });
                  // }
                  //
                  // localTranslator.stop();
                },
                child: const Text('Translate Text'),
              ),
              translatedText == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(translatedText!),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                initialValue: "Ali brushes his teeth twice a day",
                onChanged: (value) {
                  textToDetectLanguage = value;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  MLLangDetector detector = MLLangDetector();
                  final setting = MLLangDetectorSetting.create(
                      sourceText: textToDetectLanguage != null
                          ? textToDetectLanguage!
                          : "Ali brushes his teeth twice a day",
                      isRemote: false);
                  final String? res =
                      await detector.firstBestDetect(setting: setting);

                  setState(() {
                    detectedLanguage = res;
                  });
                },
                child: const Text('Detect Text Language'),
              ),
              detectedLanguage == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(detectedLanguage!),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    // Create an MLAsrRecognizer object.
                    MLAsrRecognizer recognizer = MLAsrRecognizer();

// Set a listener to track events.
                    void onResults(String s) {}

                    void onRecognizingResults(String result) {}

                    void onError(int error, String errorMessage) {}

                    void onState(int state) {}

                    recognizer.setAsrListener(
                      MLAsrListener(
                        onRecognizingResults: onRecognizingResults,
                        onResults: onResults,
                        onError: onError,
                        onState: onState,
                      ),
                    );

// Create an MLAsrSetting object to configure the recognition.
                    final setting = MLAsrSetting(
                      language: MLAsrConstants.LAN_EN_US,
                      feature: MLAsrConstants.FEATURE_WORDFLUX,
                    );

// Start recognition without a pickup UI.
//                     String result = await recognizer.startRecognizing(setting);

// Start recognition with a pickup UI.
                    String? result =
                        await recognizer.startRecognizingWithUi(setting);
                    setState(() {
                      asrText = result;
                    });

// After the recognition ends, destroy the recognizer
                    recognizer.destroy();
                  },
                  child:
                      const Text('Recognize Speech (ASR) & convert to Text')),
              asrText == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(asrText!),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                initialValue: "John brushes his teeth twice a day",
                onChanged: (value) {
                  textToSpeech = value;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  MLTtsEngine engine = MLTtsEngine();

                  void _onError(String taskId, MLTtsError err) {}

                  void _onEvent(String taskId, int eventId) {}

                  void _onAudioAvailable(String taskId,
                      MLTtsAudioFragment audioFragment, int offset) {}

                  void _onRangeStart(String taskId, int start, int end) {}

                  void _onWarn(String taskId, MLTtsWarn warn) {}

// Set a listener to track tts events.
                  engine.setTtsCallback(MLTtsCallback(
                    onError: _onError,
                    onEvent: _onEvent,
                    onAudioAvailable: _onAudioAvailable,
                    onRangeStart: _onRangeStart,
                    onWarn: _onWarn,
                  ));
                  final config = MLTtsConfig(
                    language: MLTtsConstants.TTS_EN_US,
                    synthesizeMode: MLTtsConstants.TTS_ONLINE_MODE,
                    person: MLTtsConstants.TTS_SPEAKER_MALE_EN,
                    text: textToSpeech != null
                        ? textToSpeech!
                        : "John brushes his teeth twice a day",
                  );

// Start the speech.
                  await engine.speak(config);
                },
                child: const Text('Convert Text to Speech(TTS)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp3'],
                  );

                  // if (result != null) {
                  //   setState(() {
                  //     file = result.files.first;
                  //   });
//                     MLSpeechRealTimeTranscription transcription =
//                         MLSpeechRealTimeTranscription();
//
//                     void onError(int error, String errorMessage) {
//                       print('onError Transcription');
//                     }
//
//                     void onResult(MLSpeechRealTimeTranscriptionResult result) {
//                       print('onResult Transcription completed');
//                       print(result.result);
//                       setState(() {
//                         transcriptedAudioText = result.result;
//                       });
//
//                       print('onResult Transcription completed');
//                     }
//
// // Set the listener
//                     transcription.setRealTimeTranscriptionListener(
//                       MLSpeechRealTimeTranscriptionListener(
//                         onError: onError,
//                         onResult: onResult,
//                       ),
//                     );
//
//                     final config = MLSpeechRealTimeTranscriptionConfig(
//                       language: MLSpeechRealTimeTranscriptionConfig.LAN_EN_US,
//                       punctuationEnabled: true,
//                       wordTimeOffsetEnabled: true,
//                     );
//
//                     transcription.startRecognizing(config);
//                   }

                  if (result != null) {
                    setState(() {
                      file = result.files.first;
                    });

                    MLRemoteAftEngine engine = MLRemoteAftEngine();

                    final setting = MLRemoteAftSetting(path: file!.path!);

                    void onError(String taskId, int errCode, String errMsg) {
                      print('onError Transcription');
                    }

                    void onEvent(String taskId, int eventId) {
                      print('onEvent Transcription');
                    }

                    void onInitComplete(String taskId) {
                      // here you can start the task
                      print('onInitComplete Transcription');
                      // then call getLongAftResult method periodicly to get the result
                    }

                    onUploadProgress(String taskId, double progress) {
                      print('onUploadProgress Transcription completed');
                    }

                    void onResult(String taskId, MLRemoteAftResult result) {
                      print('onResult Transcription completed');
                      print(result.text);
                      setState(() {
                        transcriptedAudioText = result.text;
                      });

                      print('onResult Transcription completed');
                    }

                    engine.setAftListener(MLRemoteAftListener(
                      onError,
                      onEvent,
                      onInitComplete,
                      onResult,
                      onUploadProgress,
                    ));

                    engine.shortRecognize(setting);
                    engine.close();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Audio File Transcription'),
                    file != null
                        ? IconButton(
                            onPressed: () async {
                              // Create a player
                              await player.setFilePath(// Load a URL
                                  file!
                                      .path!); // Schemes: (https: | file: | asset: )

                              player.playing
                                  ? player.stop()
                                  : await player.play();
                            },
                            icon: const Icon(Icons.play_arrow))
                        : Container(),
                  ],
                ),
              ),
              transcriptedAudioText == null
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(transcriptedAudioText!),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    MLSoundDetector detector = MLSoundDetector();
                    void onDetection({int? result, int? errCode}) {
                      // SOUND_DETECT_ERROR_NO_MEM = 12201;
                      // lure: fatal error.
                      // SOUND_DETECT_ERROR_FATAL_ERROR = 122
                      // lure: microphone error.
                      // SOUND_DETECT_ERROR_AUDIO = 12203;
                      // lure: internal error.
                      // SOUND_DETECT_ERROR_INTERNAL = 12298;
                      // ult type: laughter.
                      // SOUND_EVENT_TYPE_LAUGHTER = 0;
                      // ult type: baby crying sound.
                      // SOUND_EVENT_TYPE_BABY_CRY = 1;
                      // ult type: snore.
                      // SOUND_EVENT_TYPE_SNORING = 2;
                      // ult type: sneeze.
                      // SOUND_EVENT_TYPE_SNEEZE = 3;
                      // ult type: shout.
                      // SOUND_EVENT_TYPE_SCREAMING = 4;
                      // ult type: cat's meow.
                      // SOUND_EVENT_TYPE_MEOW = 5;
                      // ult type: dog's bark.
                      // SOUND_EVENT_TYPE_BARK = 6;
                      // ult type: babble of running water.
                      // SOUND_EVENT_TYPE_WATER = 7;
                      // ult type: car horn sound.
                      // SOUND_EVENT_TYPE_CAR_ALARM = 8;
                      // ult type: doorbell sound.
                      // SOUND_EVENT_TYPE_DOOR_BELL = 9;
                      // ult type: knock.
                      // SOUND_EVENT_TYPE_KNOCK = 10;
                      // ult type: fire alarm sound.
                      // SOUND_EVENT_TYPE_ALARM = 11;
                      // ult type: alarm sound.
                      // SOUND_EVENT_TYPE_STEAM_WHISTLE = 12;
                      print(
                          "$result SOUND DETECTED SOUND DETECTED SOUND DETECTED");
                      print(
                          "$errCode ERROR SOUND DETECTED SOUND DETECTED SOUND DETECTED");
                    }

                    detector.setSoundDetectListener(onDetection);

// start listening
                    detector.start();

// release resources after recognition
//                     detector.destroy();
                  },
                  child: const Text('Sound Detection'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setApiKey() async {
    MLLanguageApp().setApiKey(
        "DAEDACsUCq0Dmt1rjZ8RR13TRUxirBg7wHe7dhVNeL9WO1rzKIHtmMnZfBJGuW1U3depyH3JCa9I29NRKGIPUtjSiZIpw+gGXTuBCw==");
  }
}
