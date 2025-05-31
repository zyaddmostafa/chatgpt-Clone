import 'dart:developer';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initializeSpeechState() async {
    try {
      if (!_isInitialized) {
        _isInitialized = await _speechToText.initialize(
          onStatus: (status) {
            log('Speech status: $status');
            if (status == 'done' || status == 'notListening') {
              log('Speech recognition completed with status: $status');
            }
          },
          onError: (errorNotification) {
            log(
              'Speech error: ${errorNotification.errorMsg}, permanent: ${errorNotification.permanent}',
            );
            // Don't throw here, let the calling method handle it
          },
        );
      }
      return _isInitialized;
    } catch (e) {
      log('Failed to initialize speech: $e');
      _isInitialized = false;
      return false;
    }
  }

  Future<bool> isAvailable() async {
    try {
      if (!_isInitialized) {
        await initializeSpeechState();
      }
      return _speechToText.isAvailable;
    } catch (e) {
      log('Speech not available: $e');
      return false;
    }
  }

  Future<bool> startListen({required Function(String) onResult}) async {
    try {
      if (!_isInitialized) {
        bool initialized = await initializeSpeechState();
        if (!initialized) {
          log('Failed to initialize speech recognition');
          return false;
        }
      }

      if (!_speechToText.isAvailable) {
        log('Speech recognition not available');
        return false;
      }

      // Use a more flexible approach for starting speech recognition
      try {
        await _speechToText.listen(
          onResult: (result) {
            final recognizedWords = result.recognizedWords;
            log(
              'Speech result: $recognizedWords, isFinal: ${result.finalResult}',
            );
            if (recognizedWords.isNotEmpty) {
              onResult(recognizedWords);
            }
          },
          listenFor: const Duration(seconds: 60), // Increased timeout
          pauseFor: const Duration(seconds: 5),
          // Increased pause time
          partialResults: true,
          localeId: 'en_US',
          cancelOnError: false, // Don't cancel on error, let us handle it
          listenMode: stt.ListenMode.confirmation,
        );

        // Check if listening actually started
        if (_speechToText.isListening) {
          log('Speech recognition started successfully');
          return true;
        } else {
          log('Speech recognition failed to start');
          return false;
        }
      } catch (e) {
        log('Error in listen method: $e');
        return false;
      }
    } catch (e) {
      log('Error starting speech recognition: $e');
      return false;
    }
  }

  Future<void> stopListen() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
        log('Speech recognition stopped');
      }
    } catch (e) {
      log('Error stopping speech recognition: $e');
      rethrow;
    }
  }

  Future<void> cancel() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.cancel();
        log('Speech recognition cancelled');
      }
    } catch (e) {
      log('Error cancelling speech recognition: $e');
      rethrow;
    }
  }
}
