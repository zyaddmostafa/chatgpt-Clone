part of 'image_cubit.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImagePicking extends ImageState {}

class ImagePicked extends ImageState {
  final File image;
  ImagePicked(this.image);
}

class ImageAnalyzing extends ImageState {}

class ImageAnalyzed extends ImageState {
  final String result;
  ImageAnalyzed(this.result);
}

class ImageError extends ImageState {
  final String message;
  ImageError(this.message);
}
