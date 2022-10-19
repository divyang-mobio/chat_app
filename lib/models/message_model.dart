import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../resources/resource.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String message, name;
  @JsonKey(fromJson: _fromJson, name: 'time')
  String data;
  @JsonKey(fromJson: _typeFromJson)
  SendDataType type;

  MessageModel({
    required this.message,
    required this.name,
    required this.data,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  static String _fromJson(Timestamp date) {
    DateTime dataTime = DateTime.parse(date.toDate().toString());
    String yourDateTime = DateFormat('MM/dd hh:mm').format(dataTime);
    return yourDateTime;
  }

  static _typeFromJson(String data) {
    SendDataType type = (data == 'text')
        ? SendDataType.text
        : (data == 'image')
            ? SendDataType.image
            : SendDataType.video;
    return type;
  }
}

class MessageDetailModel {
  String id;

  MessageDetailModel({required this.id});

  factory MessageDetailModel.fromJson(Map<String, dynamic> json) =>
      MessageDetailModel(id: json['id']);
}

class PersonsModel {
  String id;

  PersonsModel({required this.id});

  factory PersonsModel.fromJson(String json) {
    return PersonsModel(id: json);
  }
}
