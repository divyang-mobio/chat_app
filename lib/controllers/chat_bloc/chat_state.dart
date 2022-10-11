part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class HaveID extends ChatState {
  String id;

  HaveID({required this.id});
}

class ChatError extends ChatState {}
