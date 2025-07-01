// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
  id: json['id'] as String,
  title: json['title'] as String,
  messages:
      (json['messages'] as List<dynamic>)
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  createdAt: ChatModel._dateTimeFromJson(json['createdAt']),
  updatedAt: ChatModel._dateTimeFromJson(json['updatedAt']),
);

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'messages': instance.messages,
  'createdAt': ChatModel._dateTimeToJson(instance.createdAt),
  'updatedAt': ChatModel._dateTimeToJson(instance.updatedAt),
};
