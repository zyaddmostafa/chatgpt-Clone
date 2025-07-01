// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      message: json['message'] as String,
      isUserMessage: json['isUserMessage'] as bool,
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
      imagepath: json['imagepath'] as String?,
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'isUserMessage': instance.isUserMessage,
      'timestamp': instance.timestamp.toIso8601String(),
      'imagepath': instance.imagepath,
    };
