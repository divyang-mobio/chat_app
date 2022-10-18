part of 'chat_list_bloc.dart';

abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoaded extends ChatListState {
  Stream<List<MessageDetailModel>> chatData;

  ChatListLoaded({required this.chatData});

}

class ChatListError extends ChatListState {}
