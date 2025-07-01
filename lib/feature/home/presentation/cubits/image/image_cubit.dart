import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatgpt/feature/home/data/apis/gemeni_service.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  final GeminiService geminiService;

  ImageCubit(this.geminiService) : super(ImageInitial());

  File? pickedImage;

  Future<void> pickImage({required bool fromCamera}) async {
    try {
      emit(ImagePicking());
      pickedImage = await geminiService.pickImage(fromCamera: fromCamera);
      if (pickedImage != null) {
        emit(ImagePicked(pickedImage!));
      } else {
        emit(ImageInitial());
      }
    } catch (e) {
      emit(ImageError("Failed to pick image: $e"));
    }
  }

  Future<String> analyzeImage({String? message}) async {
    if (pickedImage == null) {
      throw Exception("No image selected");
    }

    try {
      emit(ImageAnalyzing());
      final response = await geminiService.analyzeImage(
        pickedImage,
        message ?? 'What is in this image?',
      );

      emit(ImageAnalyzed(response));
      return response;
    } catch (e) {
      emit(ImageError("Failed to analyze image: $e"));
      rethrow;
    }
  }

  void clearPickedImage() {
    pickedImage = null;
    emit(ImageInitial());
  }

  File? get currentImage => pickedImage;
}
