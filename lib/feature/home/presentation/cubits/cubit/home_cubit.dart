import 'dart:io';
import 'package:chatgpt/feature/home/data/apis/gemeni_service.dart';
import 'package:chatgpt/feature/home/data/models/chat_message_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GeminiService geminiService;
  HomeCubit(this.geminiService) : super(HomeCubitInitial());

  final TextEditingController promptTextEditingController =
      TextEditingController();
  final List<ChatMessageModel> chatMessages = [];
  File? pickedImage;

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

  // Add this method to your HomeCubit class
  void updatePickedImage(dynamic image) {
    pickedImage = image;
    emit(state); // Or create a specific state for image picked
  }
}
