part of 'like_message_bloc.dart';

abstract class LikeMessageEvent {}

class LikeMessageData extends LikeMessageEvent {
  MessageModel messageModel;
  String id;
  ReactionType type;
  bool isGroup;

  LikeMessageData(
      {required this.messageModel,
      required this.type,
      required this.id,
      required this.isGroup});
}
