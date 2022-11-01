part of 'reply_bloc.dart';

abstract class ReplyState {}

class ReplyInitial extends ReplyState {}

class ReplyMessageData extends ReplyState {
  MessageModel messageModel;

  ReplyMessageData({required this.messageModel});
}
