import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:speech_text_tutorial/speech_text_recognizer.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechText extends StatefulWidget {
  const SpeechText({Key? key}) : super(key: key);

  @override
  State<SpeechText> createState() => _SpeechTextState();
}

class _SpeechTextState extends State<SpeechText> {
  String recognizedText = "Recognize text is";
  bool isEnabled = false;
  bool isListening = false;
  String _prevText = "";
  @override
  void initState() {
    super.initState();
    _checkSpeechAvailability();
  }

  _checkSpeechAvailability() async {
    isEnabled = await SpeechTextRecognizer.initialize();
    setState(() {});
  }

  _recognizedText() async {
    if (isListening) {
      await SpeechTextRecognizer.startListening(speechRecogListener);
    }
  }

  void speechRecogListener(SpeechRecognitionResult result) {
    //print(result.recognizedWords);
    recognizedText = '$_prevText${result.recognizedWords}';
    //recognizedText = result.recognizedWords;

    setState(() {});
    if (isListening && !SpeechTextRecognizer.isListening()) {
      _prevText += '${result.recognizedWords} ';
      _recognizedText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Speech to Text"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            child:
                !isListening ? const Icon(Icons.mic) : const Icon(Icons.stop),
            onPressed: () {
              if (isListening) {
                isListening = false;
                SpeechTextRecognizer.stopListening;
              } else {
                isListening = true;
                _recognizedText();
              }
              setState(() {});
            }),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Speech Recognition Availability $isEnabled"),
            const SizedBox(height: 15),
            Text(
              recognizedText,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
