part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  String? id;
  BuildContext context;
  String message, otherUid;
  SendDataType type;
  bool isGroup;

  SendMessage(
      {
      this.id,
      required this.context,
      required this.message,
      required this.otherUid,
      required this.type,
      required this.isGroup});
}

class SendTypeMessage extends ChatEvent {
  BuildContext context;
  String otherUid;
  String? id;
  SendDataType type;
  bool isVideo, isGroup;
  ImageSource imageSource;

  SendTypeMessage(
      {required this.isVideo,
      this.id,
      required this.context,
      required this.otherUid,
      required this.isGroup,
      required this.imageSource,
      required this.type});
}

class GetId extends ChatEvent {
  String otherUid;

  GetId({required this.otherUid});
}

class GetMessage extends ChatEvent {}
