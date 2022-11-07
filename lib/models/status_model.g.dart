// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) => StatusModel(
      id: json['id'] as String,
      image: (json['image'] as List<dynamic>)
          .map((e) => StatusImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      person: json['person'] as String,
    );

Map<String, dynamic> _$StatusModelToJson(StatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'person': instance.person,
      'image': instance.image,
    };

StatusImageModel _$StatusImageModelFromJson(Map<String, dynamic> json) =>
    StatusImageModel(
      url: json['url'] as String,
      date: StatusImageModel._fromJson(json['date'] as Timestamp),
    );

Map<String, dynamic> _$StatusImageModelToJson(StatusImageModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'date': instance.date.toIso8601String(),
    };
