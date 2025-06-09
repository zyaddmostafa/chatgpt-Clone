import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/feature/home/data/apis/gemeni_service.dart';
import 'package:chatgpt/feature/home/data/models/chat_message_model.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final GeminiService geminiService;

  MessageCubit(this.geminiService) : super(MessageInitial());

  final TextEditingController promptTextEditingController =
      TextEditingController();
  final List<ChatMessageModel> chatMessages = [];

  void loadMessages(List<ChatMessageModel> messages) {
    chatMessages.clear();
    chatMessages.addAll(messages);
    emit(MessagesLoaded(List.from(chatMessages)));
  }

  void clearMessages() {
    chatMessages.clear();
    promptTextEditingController.clear();
    emit(MessagesCleared());
  }

  Future<void> sendTextMessage(String message) async {
    if (message.trim().isEmpty) return;

    log('MessageCubit: Sending text message: $message');
    emit(MessageSending());

    try {
      // Add user message
      final userMessage = ChatMessageModel(
        message: message,
        isUserMessage: true,
      );
      chatMessages.add(userMessage);
      promptTextEditingController.clear();
      emit(MessagesLoaded(List.from(chatMessages)));

      // Get AI response
      final response = await geminiService.sendTextMessage(message);

      // Add AI response
      final aiMessage = ChatMessageModel(
        message: response,
        isUserMessage: false,
      );
      chatMessages.add(aiMessage);

      emit(MessageSent(List.from(chatMessages)));
    } catch (e) {
      log('MessageCubit: Error sending message: $e');

      // Add error message
      final errorMessage = ChatMessageModel(
        message:
            "Error: Failed to communicate with AI model. Please try again later.",
        isUserMessage: false,
      );
      chatMessages.add(errorMessage);

      emit(MessageError("Failed to send message: $e", List.from(chatMessages)));
    }
  }
}
