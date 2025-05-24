import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chatgpt/feature/home/data/apis/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: Constants.apiKey,
  );

  /// Send a text message to Gemini model and get a response
  Future<String> sendTextMessage(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return "Sorry, I couldn't generate a response.";
      }
    } catch (e) {
      debugPrint('Error sending message to Gemini: $e');
      return "Error: Failed to communicate with AI model. Please try again later.";
    }
  }

  /// Analyze an image with optional prompt text
  Future<String> analyzeImage(File? imageFile, String prompt) async {
    try {
      // Read image bytes
      final imageBytes = await imageFile!.readAsBytes();

      // Create content using the Google package's classes
      final content = Content.multi([
        TextPart(prompt.isNotEmpty ? prompt : 'What is in this image?'),
        DataPart('image/jpeg', imageBytes),
      ]);

      // Generate response with the multimodal model
      final response = await model.generateContent([content]);

      if (response.text != null) {
        return response.text!;
      } else {
        return "Sorry, I couldn't analyze the image.";
      }
    } catch (e) {
      debugPrint('Error analyzing image with Gemini: $e');
      return "Error analyzing image. Please try again later.";
    }
  }

  Future<File?> pickImage({required bool fromCamera}) async {
    final ImagePicker picker = ImagePicker();

    // Pick image from source
    final XFile? pickedImage = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedImage != null) {
      log('pickedimage');
      return File(pickedImage.path);
    }
    return null;
  }
}
