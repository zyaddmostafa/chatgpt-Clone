class ChatMessageModel {
  final String message;
  final bool isUserMessage;
  final DateTime timestamp;
  final String? imagepath; // Optional field for image files

  ChatMessageModel({
    required this.message,
    required this.isUserMessage,
    DateTime? timestamp,
    this.imagepath,
  }) : timestamp = timestamp ?? DateTime.now();
}
