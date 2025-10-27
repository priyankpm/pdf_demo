import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  Future<void> initialize() async {
    await _speech.initialize();
  }

  void startListening({required Function(String) onResult}) {
    if (!_isListening) {
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          }
        },
      );
      _isListening = true;
    }
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
  }

  void dispose() {
    _speech.stop();
  }
}