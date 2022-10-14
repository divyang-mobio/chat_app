// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String,
      phone: json['phone'] as String,
      profilePic: json['profilePic'] as String,
      status: json['status'] as bool,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'phone': instance.phone,
      'name': instance.name,
      'profilePic': instance.profilePic,
      'uid': instance.uid,
      'status': instance.status,
    };
