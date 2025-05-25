import 'dart:developer';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  Future<void> initializeSpeechState() async {
    await _speechToText.initialize(
      onStatus: (status) => log('onStatus: $status'),
      onError: (errorNotification) => log('onError: $errorNotification'),
    );
  }

  Future<bool> isAvailable() async {
    bool available = await _speechToText.initialize();
    return available;
  }

  Future<String?> startListen(String text) async {
    return await _speechToText.listen(
      onResult: (result) {
        text = result.recognizedWords;
        log('onResult: $result');
      },
    );
  }

  Future<void> stopListen() async {
    await _speechToText.stop();
  }

  Future<void> cancel() async {
    await _speechToText.cancel();
  }
}
