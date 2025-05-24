part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeCubitInitial extends HomeState {}

class HomeCubitLoading extends HomeState {}

class HomeCubitSuccess extends HomeState {
  final List<ChatMessageModel> chatMessages;

  HomeCubitSuccess(this.chatMessages);
}

class HomeCubitError extends HomeState {
  final String error;

  HomeCubitError(this.error);
}

class HomeClearPickedImageState extends HomeState {
  final File? image;
  HomeClearPickedImageState({this.image});
}

class HomeImagePickedState extends HomeState {
  final File image;

  HomeImagePickedState(this.image);
}
