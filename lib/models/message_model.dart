import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../resources/resource.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String message, name, uid, id;
  MessageModel? reply;
  @JsonKey(fromJson: _fromJson, toJson: _toJson, name: 'time')
  String data;
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  SendDataType type;

  MessageModel({
    required this.message,
    required this.name,
    required this.uid,
    this.reply,
    required this.id,
    required this.data,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  static String _fromJson(Timestamp date) {
    DateTime dataTime = DateTime.parse(date.toDate().toString());
    String yourDateTime = DateFormat('MM/ddTkk:mm').format(dataTime);
    return yourDateTime;
  }

  static int _toJson(String date) {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return timeStamp;
  }

  static _typeFromJson(String data) {
    SendDataType type = (data == 'text')
        ? SendDataType.text
        : (data == 'image')
            ? SendDataType.image
            : SendDataType.video;
    return type;
  }

  static _typeToJson(SendDataType data) {
    String type = (data == SendDataType.text)
        ? 'text'
        : (data == SendDataType.image)
            ? 'image'
            : 'video';
    return type;
  }
}

class MessageDetailModel {
  String id;

  MessageDetailModel({required this.id});

  factory MessageDetailModel.fromJson(Map<String, dynamic> json) =>
      MessageDetailModel(id: json['id']);
}
