// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      profilePic: json['profilePic'] as String,
      persons:
          (json['persons'] as List<dynamic>).map((e) => e as String).toList(),
      groups:
          (json['groups'] as List<dynamic>).map((e) => e as String).toList(),
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'profilePic': instance.profilePic,
      'uid': instance.uid,
      'groups': instance.groups,
      'persons': instance.persons,
    };
