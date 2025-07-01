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
    if (imageCubit.currentImage == null) {
      emit(HomeCubitError("No image selected"));
      return;
    }

    try {
      emit(HomeCubitLoading());

      // Add user's image message to chat first
      final userMessage = ChatMessageModel(
        message: message ?? "Please analyze this image",
        imagepath: imageCubit.currentImage?.path,
        isUserMessage: true,
        timestamp: DateTime.now(),
      );
      messageCubit.chatMessages.add(userMessage);

      // Analyze the image
      final response = await imageCubit.analyzeImage(message: message);

      // Add AI response
      final aiMessage = ChatMessageModel(
        message: response,
        isUserMessage: false,
        timestamp: DateTime.now(),
      );
      messageCubit.chatMessages.add(aiMessage);

      // Save chat after adding both messages
      await chatCubit.saveChat(messageCubit.chatMessages);

      // Clear image after successful analysis
      imageCubit.clearPickedImage();
      emit(HomeClearPickedImageState());
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

  // Image picking methods
  Future<void> pickImageFromCamera() async {
    try {
      emit(HomeCubitLoading());
      await imageCubit.pickImage(fromCamera: true);

      if (imageCubit.currentImage != null) {
        emit(HomeImagePickedState(imageCubit.currentImage!));
      } else {
        emit(HomeCubitSuccess());
      }
    } catch (e) {
      emit(HomeCubitError('Failed to pick image from camera: $e'));
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      emit(HomeCubitLoading());
      await imageCubit.pickImage(fromCamera: false);

      if (imageCubit.currentImage != null) {
        emit(HomeImagePickedState(imageCubit.currentImage!));
      } else {
        emit(HomeCubitSuccess());
      }
    } catch (e) {
      emit(HomeCubitError('Failed to pick image from gallery: $e'));
    }
  }

  void clearPickedImage() {
    imageCubit.clearPickedImage();
    emit(HomeClearPickedImageState());
  }

  // Speech to text methods
  Future<void> startListening() async {
    try {
      log('HomeCubit: Starting speech recognition');
      emit(HomeCubitLoading());

      bool started = await speechCubit.startListening();
      log('HomeCubit: Speech recognition started: $started');

      if (started) {
        emit(HomeCubitSuccess());
      } else {
        emit(
          HomeCubitError(
            'Failed to start speech recognition. Please check microphone permissions.',
          ),
        );
      }
    } catch (e) {
      log('HomeCubit: Speech recognition error: $e');
      emit(HomeCubitError('Speech recognition error: $e'));
    }
  }

  Future<void> stopListening() async {
    try {
      log('HomeCubit: Stopping speech recognition');
      await speechCubit.stopListening();
      emit(HomeCubitSuccess());
    } catch (e) {
      log('HomeCubit: Failed to stop speech recognition: $e');
      emit(HomeCubitError('Failed to stop speech recognition: $e'));
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
