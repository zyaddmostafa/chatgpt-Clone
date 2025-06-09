part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatModel> chats;
  ChatLoaded(this.chats);
}

class ChatCreated extends ChatState {
  final ChatModel chat;
  ChatCreated(this.chat);
}

class ChatSelected extends ChatState {
  final ChatModel chat;
  ChatSelected(this.chat);
}

class ChatSaved extends ChatState {
  final ChatModel chat;
  ChatSaved(this.chat);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
