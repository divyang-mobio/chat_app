part of 'chat_list_bloc.dart';

abstract class ChatListEvent {}

class GetChatList extends ChatListEvent {
  String uid;

  GetChatList({required this.uid});
}