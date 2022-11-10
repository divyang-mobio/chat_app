import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../resources/resource.dart';

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
  @JsonKey(fromJson: _typeFromJson)
  SendDataType type;

  StatusImageModel({required this.url, required this.date, required this.type});

  static DateTime _fromJson(Timestamp date) {
    DateTime dataTime = DateTime.parse(date.toDate().toString());
    return dataTime;
  }

  static _typeFromJson(String data) {
    SendDataType type = (data == 'text')
        ? SendDataType.text
        : (data == 'image')
        ? SendDataType.image
        : SendDataType.video;
    return type;
  }


  factory StatusImageModel.fromJson(Map<String, dynamic> json) =>
      _$StatusImageModelFromJson(json);
}
