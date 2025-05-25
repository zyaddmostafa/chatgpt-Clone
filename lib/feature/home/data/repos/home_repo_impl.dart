import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/home/data/apis/speech_to_text_service.dart';

class HomeRepoImpl {
  final SpeechToTextService _speechToTextService;
  HomeRepoImpl(this._speechToTextService);

  Future<String?> startListening(String text) async {
    try {
      return await _speechToTextService.startListen(text);
    } catch (e) {
      throw ErrorMessage(message: 'Error starting speech recognition: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      await _speechToTextService.stopListen();
    } catch (e) {
      throw ErrorMessage(message: 'Error stopping speech recognition: $e');
    }
  }

  Future<void> cancelListening() async {
    try {
      await _speechToTextService.cancel();
    } catch (e) {
      throw ErrorMessage(message: 'Error canceling speech recognition: $e');
    }
  }

  Future<bool> isAvailable() async {
    try {
      return await _speechToTextService.isAvailable();
    } catch (e) {
      throw ErrorMessage(message: 'Error checking availability: $e');
    }
  }
}
