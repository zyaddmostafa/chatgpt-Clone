import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/feature/home/data/models/chat_model.dart';
import 'package:chatgpt/feature/home/data/models/chat_message_model.dart';
import 'package:chatgpt/feature/home/data/repos/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository = ChatRepository();

  List<ChatModel> _chatHistory = [];
  ChatModel? _currentChat;

  ChatCubit() : super(ChatInitial()) {
    loadChatHistory();
  }

  List<ChatModel> get chatHistory => _chatHistory;
  ChatModel? get currentChat => _currentChat;

  // Load chat history
  Future<void> loadChatHistory() async {
    try {
      emit(ChatLoading());
      _chatHistory = await _chatRepository.getUserChats();
      emit(ChatLoaded(_chatHistory));
    } catch (e) {
      emit(ChatError('Failed to load chat history'));
    }
  }

  // Create new chat
  Future<void> createNewChat() async {
    try {
      _currentChat = null;

      // Create a new chat with default structure but don't save it yet
      final now = DateTime.now();
      _currentChat = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Chat',
        messages: [],
        createdAt: now,
        updatedAt: now,
      );

      emit(ChatCreated(_currentChat!));
    } catch (e) {
      emit(ChatError('Failed to create new chat'));
    }
  }

  // Clear current chat and create a new one
  Future<void> clearAndCreateNewChat() async {
    try {
      _currentChat = null;
      await _chatRepository.deleteAllChats();
      await loadChatHistory();
      await createNewChat();
    } catch (e) {
      emit(ChatError('Failed to clear and create new chat'));
    }
  }

  // Load existing chat
  Future<void> loadChat(String chatId) async {
    try {
      emit(ChatLoading());
      final chat = await _chatRepository.getChat(chatId);
      if (chat != null) {
        _currentChat = chat;
        emit(ChatSelected(chat));
      } else {
        emit(ChatError('Chat not found'));
      }
    } catch (e) {
      emit(ChatError('Failed to load chat: $e'));
    }
  }

  // Save current chat
  Future<void> saveChat(List<ChatMessageModel> messages) async {
    if (messages.isEmpty || _currentChat == null) {
      log('ChatCubit: No messages or current chat to save - skipping save');
      return;
    }

    try {
      log('ChatCubit: Saving current chat with ${messages.length} messages');

      final now = DateTime.now();
      final title = _generateChatTitle(messages.first.message);

      final updatedTitle =
          _currentChat!.title == 'New Chat' ? title : _currentChat!.title;
      _currentChat = _currentChat!.copyWith(
        title: updatedTitle,
        messages: List.from(messages),
        updatedAt: now,
      );

      await _chatRepository.saveChat(_currentChat!);
      await loadChatHistory();
      emit(ChatSaved(_currentChat!));
      log('ChatCubit: Chat saved successfully');
    } catch (e) {
      log('ChatCubit: Error saving chat: $e');
      emit(ChatError('Failed to save chat: $e'));
    }
  }

  String _generateChatTitle(String firstMessage) {
    String title =
        firstMessage.length > 50
            ? firstMessage.substring(0, 50) + '...'
            : firstMessage;

    final endIndex = title.indexOf(RegExp(r'[.?!]'));
    if (endIndex != -1 && endIndex < 30) {
      title = title.substring(0, endIndex + 1);
    }

    return title;
  }

  // Delete a chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _chatRepository.deleteChat(chatId);
      await loadChatHistory();

      // If we deleted the current chat, create a new one
      if (_currentChat?.id == chatId) {
        await createNewChat();
      }
    } catch (e) {
      emit(ChatError('Failed to delete chat'));
    }
  }
}
