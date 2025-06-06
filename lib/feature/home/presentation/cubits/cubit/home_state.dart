part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeCubitInitial extends HomeState {}

final class HomeCubitLoading extends HomeState {}

final class HomeCubitSuccess extends HomeState {}

final class HomeCubitError extends HomeState {
  final String errorMessage;
  HomeCubitError(this.errorMessage);
}

final class HomeCubitFailure extends HomeState {
  final String errorMessage;
  HomeCubitFailure({required this.errorMessage});
}

final class HomeImagePickedState extends HomeState {
  final File pickedImage;
  HomeImagePickedState(this.pickedImage);
}

final class HomeClearPickedImageState extends HomeState {}

final class HomeSpeechToTextLoadingState extends HomeState {
  final List<ChatMessageModel> chatMessages;
  final String? isRelatedTo;
  HomeSpeechToTextLoadingState(this.chatMessages, {this.isRelatedTo});
}

final class HomeSpeechToTextSuccessState extends HomeState {
  final String recognizedText;
  HomeSpeechToTextSuccessState(this.recognizedText);
}

final class HomeSpeechToTextStoppedState extends HomeState {
  final String recognizedText;
  HomeSpeechToTextStoppedState(this.recognizedText);
}

final class HomeSpeechToTextErrorState extends HomeState {
  final String errorMessage;
  HomeSpeechToTextErrorState(this.errorMessage);
}
