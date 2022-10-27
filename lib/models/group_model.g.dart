// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
      groupName: json['groupName'] as String,
      id: json['id'] as String,
      image: json['image'] as String,
      persons:
          (json['persons'] as List<dynamic>).map((e) => e as String).toList(),
      admin: (json['admin'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'admin': instance.admin,
      'persons': instance.persons,
      'id': instance.id,
      'groupName': instance.groupName,
      'image': instance.image,
    };
