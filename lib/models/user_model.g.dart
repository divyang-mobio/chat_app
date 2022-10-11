// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      profilePic: json['profilePic'] as String,
      status: json['status'] as bool,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'profilePic': instance.profilePic,
      'uid': instance.uid,
      'status': instance.status,
    };
