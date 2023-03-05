import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTextRecognizer {
  static SpeechToText speechToText = SpeechToText();

  static initialize() async {
    bool status = await speechToText.initialize();
    return status;
  }

  static startListening(Function(SpeechRecognitionResult) recogFn) async {
    try {
      await speechToText.listen(
          listenMode: ListenMode.dictation,
          onResult: recogFn,
          listenFor: const Duration(seconds: 90));
    } catch (e) {
      print(e);
    }
  }

  static void stopListening() async {
    await speechToText.stop();
  }

  static bool isListening() {
    return speechToText.isListening;
  }
}
