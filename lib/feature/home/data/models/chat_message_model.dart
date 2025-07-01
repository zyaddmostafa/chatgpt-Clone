import 'package:json_annotation/json_annotation.dart';
part 'chat_message_model.g.dart';

@JsonSerializable()
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}
