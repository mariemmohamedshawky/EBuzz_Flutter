import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  static const String routeName = 'speech-screen';
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
      debugLogging: true,
      //finalTimeout: Duration(milliseconds: 0)
    );
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: _hasSpeech ? null : initSpeechState,
                child: Text(
                  translator.translate(
                    'speech-Initialize',
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
              onPressed:
                  !_hasSpeech || speech.isListening ? null : startListening,
              child: Text(
                translator.translate(
                  'speech-start',
                ),
              ),
            ),
            TextButton(
              onPressed: speech.isListening ? stopListening : null,
              child: Text(
                translator.translate(
                  'speech-stop',
                ),
              ),
            ),
            TextButton(
              onPressed: speech.isListening ? cancelListening : null,
              child: Text(
                translator.translate(
                  'speech-cancel',
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            DropdownButton(
              onChanged: (selectedVal) => _switchLang(selectedVal),
              value: _currentLocaleId,
              items: _localeNames
                  .map(
                    (localeName) => DropdownMenuItem(
                      value: localeName.localeId,
                      child: Text(localeName.name),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  translator.translate(
                    'speech-recognize',
                  ),
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).selectedRowColor,
                      child: Center(
                        child: Text(
                          lastWords,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.mic),
                            onPressed: () => null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  translator.translate(
                    'speech-error',
                  ),
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              Center(
                child: Text(lastError),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: speech.isListening
                ? Text(
                    translator.translate(
                      'speech-listen',
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : Text(
                    translator.translate(
                      'speech-not-listen',
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ]),
    );
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
