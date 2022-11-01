part of 'reply_bloc.dart';

abstract class ReplyEvent {}

class ReplyMessage extends ReplyEvent {
  MessageModel messageModel;

  ReplyMessage({required this.messageModel});
}

class CancelReply extends ReplyEvent {}
