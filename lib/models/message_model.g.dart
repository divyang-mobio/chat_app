// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      message: json['message'] as String,
      name: json['name'] as String,
      data: MessageModel._fromJson(json['time'] as Timestamp),
      type: MessageModel._typeFromJson(json['type'] as String),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'name': instance.name,
      'time': instance.data,
      'type': _$SendDataTypeEnumMap[instance.type]!,
    };

const _$SendDataTypeEnumMap = {
  SendDataType.image: 'image',
  SendDataType.text: 'text',
  SendDataType.file: 'file',
  SendDataType.video: 'video',
};
