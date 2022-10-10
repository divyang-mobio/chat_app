import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String message, name;
  @JsonKey(fromJson: _fromJson, toJson: _toJson, name: 'time')
  DateTime data;

  MessageModel({required this.message, required this.name, required this.data});

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  static DateTime _fromJson(Timestamp date) =>
      DateTime.parse(date.toDate().toString());

  static int _toJson(DateTime time) => time.millisecondsSinceEpoch;
}
