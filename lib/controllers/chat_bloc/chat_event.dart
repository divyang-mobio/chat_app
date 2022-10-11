part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  String? id;
  BuildContext context;
  String message, name, yourUid, otherUid;

  SendMessage(
      {required this.name,
      this.id,
      required this.context,
      required this.message,
      required this.otherUid,
      required this.yourUid});
}

class GetId extends ChatEvent {
  String yourUid, otherUid;

  GetId({required this.otherUid, required this.yourUid});
}

class GetMessage extends ChatEvent {}
