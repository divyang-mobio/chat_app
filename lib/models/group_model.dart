import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  List<String> admin, persons;
  String id, groupName, image;

  GroupModel(
      {required this.groupName,
      required this.id,
      required this.image,
      required this.persons,
      required this.admin});

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}
