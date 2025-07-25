import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/feature/home/data/repos/home_repo_impl.dart';

part 'speech_state.dart';

class SpeechCubit extends Cubit<SpeechState> {
  final HomeRepoImpl homeRepo;

  SpeechCubit(this.homeRepo) : super(SpeechInitial());

  bool isListening = false;
  String recognizedText = '';

  Future<bool> startListening() async {
    try {
      log('SpeechCubit: Starting speech recognition');
      if (isListening) {
        log('SpeechCubit: Already listening, stopping first');
        await stopListening();
      }

      // Reset state
      recognizedText = '';
      isListening = false;

      // Check availability first
      bool available = await homeRepo.isAvailable();
      log('SpeechCubit: Speech availability check: $available');
      if (!available) {
        log('SpeechCubit: Speech recognition not available');
        emit(SpeechError("Speech recognition not available on this device"));
        return false;
      }

      // Emit listening state before starting
      emit(SpeechListening());
      log('SpeechCubit: Emitted SpeechListening state');

      // Start listening with detailed error handling
      bool started = await homeRepo.startListening(
        onResult: (text) {
          log('SpeechCubit: Speech result received: $text');
          recognizedText = text;
          if (text.isNotEmpty) {
            emit(SpeechResult(recognizedText));
            log('SpeechCubit: Emitted SpeechResult with: $text');
          }
        },
      );

      log('SpeechCubit: startListening returned: $started');

      if (started) {
        isListening = true;
        log('SpeechCubit: Speech recognition started successfully');
        return true;
      } else {
        isListening = false;
        log('SpeechCubit: Failed to start speech recognition');
        emit(
          SpeechError(
            "Failed to start speech recognition. Please check microphone permissions.",
          ),
        );
        return false;
      }
    } catch (e) {
      log('SpeechCubit: Exception in startListening: $e');
      isListening = false;
      emit(SpeechError("Speech recognition error: ${e.toString()}"));
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      log('SpeechCubit: Stopping speech recognition');
      if (isListening) {
        await homeRepo.stopListening();
        isListening = false;

        if (recognizedText.isNotEmpty) {
          emit(SpeechStopped(recognizedText));
        } else {
          emit(SpeechError("No speech was recognized"));
        }
        log('SpeechCubit: Speech recognition stopped');
      }
    } catch (e) {
      log('SpeechCubit: Error stopping speech recognition: $e');
      isListening = false;
      emit(SpeechError("Failed to stop listening: $e"));
    }
  }
}
