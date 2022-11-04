// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) => StatusModel(
      id: json['id'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      person: json['person'] as String,
    );

Map<String, dynamic> _$StatusModelToJson(StatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'person': instance.person,
      'image': instance.image,
    };
