// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      message: json['message'] as String,
      name: json['name'] as String,
      uid: json['uid'] as String,
      reply: json['reply'] == null
          ? null
          : MessageModel.fromJson(json['reply'] as Map<String, dynamic>),
      id: json['id'] as String,
      data: MessageModel._fromJson(json['time'] as Timestamp),
      type: MessageModel._typeFromJson(json['type'] as String),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'name': instance.name,
      'uid': instance.uid,
      'id': instance.id,
      'reply': instance.reply,
      'time': MessageModel._toJson(instance.data),
      'type': MessageModel._typeToJson(instance.type),
    };
