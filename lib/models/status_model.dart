import 'package:json_annotation/json_annotation.dart';

part 'status_model.g.dart';

@JsonSerializable()
class StatusModel {
  String id, person;
  List<String> image;

  StatusModel({required this.id, required this.image, required this.person});

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);
}
