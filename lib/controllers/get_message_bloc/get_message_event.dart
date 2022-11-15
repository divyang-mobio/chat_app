part of 'get_message_bloc.dart';

abstract class GetMessageEvent {}

class MessageId extends GetMessageEvent {
  String id;
  bool isGroup;

  MessageId({required this.id, required this.isGroup});
}
