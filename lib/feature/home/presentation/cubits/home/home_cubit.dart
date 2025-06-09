import 'dart:developer';
import 'dart:io';
import 'package:chatgpt/feature/home/data/apis/gemeni_service.dart';
import 'package:chatgpt/feature/home/data/models/chat_message_model.dart';
import 'package:chatgpt/feature/home/data/repos/home_repo_impl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/feature/home/data/models/chat_model.dart';

// Import other cubits
import 'package:chatgpt/feature/home/presentation/cubits/chat/chat_cubit.dart';
import 'package:chatgpt/feature/home/presentation/cubits/message/message_cubit.dart';
import 'package:chatgpt/feature/home/presentation/cubits/image/image_cubit.dart';
import 'package:chatgpt/feature/home/presentation/cubits/speech/speech_cubit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GeminiService geminiService;
  final HomeRepoImpl homeRepo;
  final ChatCubit chatCubit;
  final MessageCubit messageCubit;
  final ImageCubit imageCubit;
  final SpeechCubit speechCubit;

  HomeCubit({
    required this.geminiService,
    required this.homeRepo,
    required this.chatCubit,
    required this.messageCubit,
    required this.imageCubit,
    required this.speechCubit,
  }) : super(HomeCubitInitial()) {
    _initialize();
  }

  // Initialize the cubit
  Future<void> _initialize() async {
    try {
      emit(HomeCubitLoading());
      // Initialize child cubits if needed
      await Future.delayed(Duration(milliseconds: 100)); // Small delay for UI
      emit(HomeCubitSuccess());
    } catch (e) {
      log('HomeCubit: Error initializing: $e');
      emit(HomeCubitError('Failed to initialize'));
    }
  }

  // Coordinate sending text message
  Future<void> sendTextMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      emit(HomeCubitLoading());

      await messageCubit.sendTextMessage(message);

      // Save chat after sending message
      await chatCubit.saveChat(messageCubit.chatMessages);

      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError("Failed to send message: $e"));
    }
  }

  // Coordinate image analysis with message
  Future<void> analyzeImageWithMessage({String? message}) async {
    try {
      emit(HomeCubitLoading());

      final response = await imageCubit.analyzeImage(message: message);

      // Add image message to chat
      messageCubit.chatMessages.add(
        ChatMessageModel(
          message: message ?? "Image analyzed successfully.",
          imagepath: imageCubit.currentImage?.path,
          isUserMessage: true,
        ),
      );

      // Add AI response
      messageCubit.chatMessages.add(
        ChatMessageModel(message: response, isUserMessage: false),
      );

      // Clear image and save chat
      imageCubit.clearPickedImage();
      await chatCubit.saveChat(messageCubit.chatMessages);

      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError("Failed to analyze image: $e"));
    }
  }

  // Load a specific chat
  Future<void> loadChat(String chatId) async {
    try {
      emit(HomeCubitLoading());
      await chatCubit.loadChat(chatId);

      // Load messages into message cubit
      if (chatCubit.currentChat != null) {
        messageCubit.loadMessages(chatCubit.currentChat!.messages);
      }

      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError('Failed to load chat: $e'));
    }
  }

  // Create new chat
  Future<void> createNewChat() async {
    try {
      await chatCubit.createNewChat();
      messageCubit.clearMessages();
      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError('Failed to create new chat'));
    }
  }

  // Clear and create new chat
  Future<void> clearAndCreateNewChat() async {
    try {
      await chatCubit.clearAndCreateNewChat();
      messageCubit.clearMessages();
      emit(HomeCubitSuccess());
    } catch (e) {
      emit(HomeCubitError('Failed to clear and create new chat'));
    }
  }

  // Get current state information
  List<ChatMessageModel> get chatMessages => messageCubit.chatMessages;
  TextEditingController get promptTextEditingController =>
      messageCubit.promptTextEditingController;
  List<ChatModel> get chatHistory => chatCubit.chatHistory;
  ChatModel? get currentChat => chatCubit.currentChat;
  File? get pickedImage => imageCubit.currentImage;
  bool get isListening => speechCubit.isListening;
  String get recognizedText => speechCubit.recognizedText;
}
