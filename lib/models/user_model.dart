import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String email, name, profilePic, uid;
  List<String> groups, persons;

  UserModel(
      {required this.name,
      required this.email,
      required this.profilePic,
      required this.persons,
      required this.groups,
      required this.uid});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
