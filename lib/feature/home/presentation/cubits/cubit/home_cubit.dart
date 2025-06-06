import 'dart:developer';
import 'dart:io';
import 'package:chatgpt/feature/home/data/apis/gemeni_service.dart';
import 'package:chatgpt/feature/home/data/models/chat_message_model.dart';
import 'package:chatgpt/feature/home/data/repos/home_repo_impl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/feature/home/data/models/chat_model.dart';
import 'package:chatgpt/feature/home/data/repos/chat_repository.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GeminiService geminiService;
  final HomeRepoImpl homeRepo;
  HomeCubit(this.geminiService, this.homeRepo) : super(HomeCubitInitial()) {
    // Initialize by loading chat history
    _initialize();
  }

  final TextEditingController promptTextEditingController =
      TextEditingController();
  final List<ChatMessageModel> chatMessages = [];
  File? pickedImage;
  bool isListening = false;
  String recognizedText = '';

  final ChatRepository _chatRepository = ChatRepository();

  List<ChatModel> _chatHistory = [];
  ChatModel? _currentChat;

  List<ChatModel> get chatHistory => _chatHistory;
  ChatModel? get currentChat => _currentChat;

  // Load chat history
  Future<void> loadChatHistory() async {
    try {
      _chatHistory = await _chatRepository.getUserChats();
      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError('Failed to load chat history'));
    }
  }

  // Create new chat
  Future<void> createNewChat() async {
    try {
      _currentChat = null;
      chatMessages.clear();

      // Create a new chat with default structure but don't save it yet
      final now = DateTime.now();
      _currentChat = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Chat',
        messages: [],
        createdAt: now,
        updatedAt: now,
      );

      // Don't save empty chat to Firebase - only save when first message is sent
      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError('Failed to create new chat'));
    }
  }

  // Clear current chat and create a new one
  Future<void> clearAndCreateNewChat() async {
    try {
      _currentChat = null;
      chatMessages.clear();
      await _chatRepository.deleteAllChats();
      await loadChatHistory(); // Clear history if needed
      await createNewChat();
    } catch (e) {
      emit(HomeCubitError('Failed to clear and create new chat'));
    }
  }

  // Load existing chat
  Future<void> loadChat(String chatId) async {
    try {
      emit(HomeCubitLoading());
      final chat = await _chatRepository.getChat(chatId);
      if (chat != null) {
        _currentChat = chat;
        chatMessages.clear();
        chatMessages.addAll(chat.messages);
        emit(HomeCubitSuccess());
      } else {
        emit(HomeCubitError('Chat not found'));
      }
    } catch (e) {
      emit(HomeCubitError('Failed to load chat: $e'));
    }
  }

  // Initialize the cubit
  Future<void> _initialize() async {
    try {
      await loadChatHistory();
    } catch (e) {
      log('HomeCubit: Error initializing: $e');
      emit(HomeCubitError('Failed to initialize'));
    }
  }

  void sendTextMessage(String message) async {
    if (message.trim().isEmpty) return;

    log('HomeCubit: Sending text message: $message');
    emit(HomeCubitLoading());
    try {
      final response = await geminiService.sendTextMessage(message);

      // Add user message
      chatMessages.add(ChatMessageModel(message: message, isUserMessage: true));
      log(
        'HomeCubit: Added user message. Total messages: ${chatMessages.length}',
      );

      promptTextEditingController.clear();
      emit(HomeCubitSuccess());

      // Add AI response
      chatMessages.add(
        ChatMessageModel(message: response, isUserMessage: false),
      );
      log(
        'HomeCubit: Added AI response. Total messages: ${chatMessages.length}',
      );

      // Save chat after sending message
      log('HomeCubit: Saving chat with ${chatMessages.length} messages');
      await saveCurrentChat();
      emit(HomeCubitSuccess());
    } catch (e) {
      log('HomeCubit: Error sending message: $e');
      emit(HomeCubitError("Failed to send message: $e"));
      promptTextEditingController.clear();
      chatMessages.add(
        ChatMessageModel(
          message:
              "Error: Failed to communicate with AI model. Please try again later.",
          isUserMessage: false,
        ),
      );
      emit(HomeCubitSuccess()); // Emit success to show error message
    }
  }

  // Save current chat
  Future<void> saveCurrentChat() async {
    if (chatMessages.isEmpty) {
      log('HomeCubit: No messages to save - skipping save');
      return;
    }

    try {
      log(
        'HomeCubit: Saving current chat with ${chatMessages.length} messages',
      );

      // Debug: Check if messages can be serialized
      for (int i = 0; i < chatMessages.length; i++) {
        try {
          final json = chatMessages[i].toJson();
          log('HomeCubit: Message $i serialized: $json');
        } catch (e) {
          log('HomeCubit: Error serializing message $i: $e');
        }
      }

      final now = DateTime.now();
      final title = _generateChatTitle(chatMessages.first.message);

      if (_currentChat == null) {
        log('HomeCubit: Creating new chat');
        // Create new chat
        _currentChat = ChatModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          messages: List.from(chatMessages),
          createdAt: now,
          updatedAt: now,
        );
      } else {
        log('HomeCubit: Updating existing chat');
        // Update existing chat with new title if it was "New Chat"
        final updatedTitle =
            _currentChat!.title == 'New Chat' ? title : _currentChat!.title;
        _currentChat = _currentChat!.copyWith(
          title: updatedTitle,
          messages: List.from(chatMessages),
          updatedAt: now,
        );
      }

      log(
        'HomeCubit: Current chat has ${_currentChat!.messages.length} messages',
      );
      await _chatRepository.saveChat(_currentChat!);
      await loadChatHistory(); // Refresh chat history
      log('HomeCubit: Chat saved successfully');
    } catch (e) {
      log('HomeCubit: Error saving chat: $e');
      // Don't emit error state here to avoid disrupting the chat flow
    }
  }

  String _generateChatTitle(String firstMessage) {
    // Take first 50 characters or until first question mark/period
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

  void pickImage({required bool fromCamera}) async {
    try {
      pickedImage = await geminiService.pickImage(fromCamera: fromCamera);
      if (pickedImage != null) {
        emit(HomeImagePickedState(pickedImage!));
      } else {
        emit(HomeClearPickedImageState());
      }
    } catch (e) {
      emit(HomeCubitError("Failed to pick image: $e"));
    }
  }

  void imageAnalyze({String? message}) async {
    emit(HomeCubitLoading());
    try {
      final response = await geminiService.analyzeImage(
        pickedImage,
        message ?? 'What is in this image?',
      );
      promptTextEditingController.clear();
      chatMessages.add(
        ChatMessageModel(
          message: message ?? "Image analyzed successfully.",
          imagepath: pickedImage?.path,
          isUserMessage: true,
        ),
      );
      // Clear the image after analysis is complete
      clearPickedImage();
      emit(HomeCubitSuccess());

      chatMessages.add(
        ChatMessageModel(message: response, isUserMessage: false),
      );

      // Save chat after image analysis
      await saveCurrentChat();
      emit(HomeCubitSuccess());
    } catch (e) {
      clearPickedImage();
      emit(HomeCubitError("Failed to analyze image: $e"));
      promptTextEditingController.clear();
      chatMessages.add(
        ChatMessageModel(
          message: "Error: Failed to analyze image. Please try again later.",
          isUserMessage: false,
        ),
      );
    }
  }

  void clearPickedImage() {
    pickedImage = null;
    emit(HomeClearPickedImageState());
  }

  Future<bool> startListening() async {
    try {
      log('HomeCubit: Starting speech recognition');
      if (isListening) {
        log('HomeCubit: Already listening, stopping first');
        await stopListening();
      }

      // Check availability first
      bool available = await homeRepo.isAvailable();
      if (!available) {
        log('HomeCubit: Speech recognition not available');
        emit(
          HomeSpeechToTextErrorState(
            "Speech recognition not available on this device",
          ),
        );
        return false;
      }

      // Reset state
      recognizedText = '';

      // Emit loading state
      emit(HomeSpeechToTextLoadingState(chatMessages, isRelatedTo: "speech"));

      // Start listening
      bool started = await homeRepo.startListening(
        onResult: (text) {
          log('HomeCubit: Speech result received: $text');
          recognizedText = text;
          if (text.isNotEmpty) {
            emit(HomeSpeechToTextSuccessState(recognizedText));
          }
        },
      );

      if (started) {
        isListening = true;
        log('HomeCubit: Speech recognition started successfully');
        return true;
      } else {
        isListening = false;
        log('HomeCubit: Failed to start speech recognition');
        emit(
          HomeSpeechToTextErrorState(
            "Failed to start speech recognition. Please check microphone permissions.",
          ),
        );
        return false;
      }
    } catch (e) {
      log('HomeCubit: Error starting speech recognition: $e');
      isListening = false;
      emit(
        HomeSpeechToTextErrorState("Speech recognition error: ${e.toString()}"),
      );
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      log('HomeCubit: Stopping speech recognition');
      if (isListening) {
        await homeRepo.stopListening();
        isListening = false;
        // Only emit stopped state if we have recognized text
        if (recognizedText.isNotEmpty) {
          emit(HomeSpeechToTextStoppedState(recognizedText));
        } else {
          emit(HomeSpeechToTextErrorState("No speech was recognized"));
        }
        log('HomeCubit: Speech recognition stopped');
      }
    } catch (e) {
      log('HomeCubit: Error stopping speech recognition: $e');
      isListening = false;
      emit(HomeSpeechToTextErrorState("Failed to stop listening: $e"));
    }
  }

  // Delete a chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _chatRepository.deleteChat(chatId);
      await loadChatHistory();

      // If we deleted the current chat, create a new one
      if (_currentChat?.id == chatId) {
        createNewChat();
      }
      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError('Failed to delete chat'));
    }
  }
}
