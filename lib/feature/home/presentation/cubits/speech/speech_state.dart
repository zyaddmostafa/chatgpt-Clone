part of 'speech_cubit.dart';

abstract class SpeechState {}

class SpeechInitial extends SpeechState {}

class SpeechListening extends SpeechState {}

class SpeechResult extends SpeechState {
  final String text;
  SpeechResult(this.text);
}

class SpeechStopped extends SpeechState {
  final String finalText;
  SpeechStopped(this.finalText);
}

class SpeechError extends SpeechState {
  final String message;
  SpeechError(this.message);
}
