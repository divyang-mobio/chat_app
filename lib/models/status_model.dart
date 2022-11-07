import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'status_model.g.dart';

@JsonSerializable()
class StatusModel {
  String id, person;
  List<StatusImageModel> image;

  StatusModel({required this.id, required this.image, required this.person});

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);
}

@JsonSerializable()
class StatusImageModel {
  String url;
  @JsonKey(fromJson: _fromJson)
  DateTime date;

  StatusImageModel({required this.url, required this.date});

  static DateTime _fromJson(Timestamp date) {
    DateTime dataTime = DateTime.parse(date.toDate().toString());
    return dataTime;
  }


  factory StatusImageModel.fromJson(Map<String, dynamic> json) =>
      _$StatusImageModelFromJson(json);
}
