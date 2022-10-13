part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  String? id;
  BuildContext context;
  String message, name, yourUid, otherUid;
  SendDataType type;

  SendMessage(
      {required this.name,
      this.id,
      required this.context,
      required this.message,
      required this.otherUid,
      required this.type,
      required this.yourUid});
}

class SendTypeMessage extends ChatEvent {
  BuildContext context;
  String otherUid;
  SendDataType type;
  bool isVideo;
  ImageSource imageSource;

  SendTypeMessage(
      {required this.isVideo,
        required this.context,
        required this.otherUid,
        required this.imageSource,
        required this.type});
}

class GetId extends ChatEvent {
  String yourUid, otherUid;

  GetId({required this.otherUid, required this.yourUid});
}

class GetMessage extends ChatEvent {}
