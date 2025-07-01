part of 'message_cubit.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageSending extends MessageState {}

class MessagesLoaded extends MessageState {
  final List<ChatMessageModel> messages;
  MessagesLoaded(this.messages);
}

class MessageSent extends MessageState {
  final List<ChatMessageModel> messages;
  MessageSent(this.messages);
}

class MessagesCleared extends MessageState {}

class MessageError extends MessageState {
  final String error;
  final List<ChatMessageModel> messages;
  MessageError(this.error, this.messages);
}
