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
    )..like = (json['like'] as List<dynamic>?)
        ?.map((e) => LikeModel.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'name': instance.name,
      'uid': instance.uid,
      'id': instance.id,
      'reply': instance.reply,
      'like': instance.like,
      'time': MessageModel._toJson(instance.data),
      'type': MessageModel._typeToJson(instance.type),
    };

LikeModel _$LikeModelFromJson(Map<String, dynamic> json) => LikeModel(
      id: json['id'] as String,
      type: LikeModel._typeFromJson(json['type'] as String),
    );

Map<String, dynamic> _$LikeModelToJson(LikeModel instance) => <String, dynamic>{
      'id': instance.id,
      'type': LikeModel._typeToJson(instance.type),
    };
