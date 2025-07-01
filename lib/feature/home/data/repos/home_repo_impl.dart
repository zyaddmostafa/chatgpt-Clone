import 'dart:developer';
import 'package:chatgpt/core/widgets/error_message.dart';
import 'package:chatgpt/feature/home/data/apis/speech_to_text_service.dart';

class HomeRepoImpl {
  final SpeechToTextService _speechToTextService;
  HomeRepoImpl(this._speechToTextService);

  Future<bool> startListening({required Function(String) onResult}) async {
    try {
      log('HomeRepo: Starting speech recognition');
      bool started = await _speechToTextService.startListen(
        onResult: (result) {
          log('HomeRepo: Speech recognized: $result');
          onResult(result);
        },
      );
      log('HomeRepo: Speech recognition started: $started');
      return started;
    } catch (e) {
      log('HomeRepo: Error starting speech recognition: $e');
      return false; // Return false instead of throwing
    }
  }

  Future<void> stopListening() async {
    try {
      log('HomeRepo: Stopping speech recognition');
      await _speechToTextService.stopListen();
    } catch (e) {
      log('HomeRepo: Error stopping speech recognition: $e');
      throw ErrorMessage(message: 'Error stopping speech recognition: $e');
    }
  }

  Future<void> cancelListening() async {
    try {
      log('HomeRepo: Cancelling speech recognition');
      await _speechToTextService.cancel();
    } catch (e) {
      log('HomeRepo: Error canceling speech recognition: $e');
      throw ErrorMessage(message: 'Error canceling speech recognition: $e');
    }
  }

  Future<bool> isAvailable() async {
    try {
      log('HomeRepo: Checking speech recognition availability');
      bool available = await _speechToTextService.isAvailable();
      log('HomeRepo: Speech recognition available: $available');
      return available;
    } catch (e) {
      log('HomeRepo: Error checking availability: $e');
      return false;
    }
  }
}
