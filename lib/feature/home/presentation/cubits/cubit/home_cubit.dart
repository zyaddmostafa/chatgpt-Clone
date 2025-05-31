import 'dart:developer';
import 'dart:io';
import 'package:chatgpt/feature/home/data/apis/gemeni_service.dart';
import 'package:chatgpt/feature/home/data/models/chat_message_model.dart';
import 'package:chatgpt/feature/home/data/repos/home_repo_impl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GeminiService geminiService;
  final HomeRepoImpl homeRepo;
  HomeCubit(this.geminiService, this.homeRepo) : super(HomeCubitInitial());

  final TextEditingController promptTextEditingController =
      TextEditingController();
  final List<ChatMessageModel> chatMessages = [];
  File? pickedImage;
  bool isListening = false;
  String recognizedText = '';

  void sendTextMessage(String message) async {
    emit(HomeCubitLoading());
    try {
      final response = await geminiService.sendTextMessage(message);
      chatMessages.add(ChatMessageModel(message: message, isUserMessage: true));
      promptTextEditingController.clear();
      emit(HomeCubitSuccess(chatMessages));

      chatMessages.add(
        ChatMessageModel(message: response, isUserMessage: false),
      );
    } catch (e) {
      emit(HomeCubitError("Failed to send message: $e"));
      promptTextEditingController.clear();
      chatMessages.add(
        ChatMessageModel(
          message:
              "Error: Failed to communicate with AI model. Please try again later.",
          isUserMessage: false,
        ),
      );
    }
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
      emit(HomeCubitSuccess(chatMessages));

      chatMessages.add(
        ChatMessageModel(message: response, isUserMessage: false),
      );
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
}
