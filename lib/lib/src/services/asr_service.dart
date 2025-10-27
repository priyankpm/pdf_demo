import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ASRService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  final StreamController<String> _speechController = StreamController<String>.broadcast();

  Stream<String> get speechStream => _speechController.stream;

  Future<bool> initialize() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        debugPrint('Speech status: $status');
        if (status == 'done' && _isListening) {
          _stopListening();
        }
      },
      onError: (error) => debugPrint('Speech error: $error'),
    );
    return available;
  }

  void startListening() {
    if (!_isListening) {
      _isListening = true;
      _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          _speechController.add(_lastWords);
          debugPrint('Speech recognized: $_lastWords');
        },
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US',
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    }
  }

  void _stopListening() {
    if (_isListening) {
      _isListening = false;
      _speechToText.stop();
    }
  }

  void toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      startListening();
    }
  }

  void dispose() {
    _stopListening();
    _speechController.close();
  }

  bool get isListening => _isListening;
  String get lastWords => _lastWords;
}