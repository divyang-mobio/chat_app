import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String phone, name, profilePic, uid;
  bool status;

  UserModel(
      {required this.name,
      required this.phone,
      required this.profilePic,
      required this.status,
      required this.uid});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
