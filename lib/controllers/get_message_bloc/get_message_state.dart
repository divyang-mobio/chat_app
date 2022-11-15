part of 'get_message_bloc.dart';

abstract class GetMessageState {}

class GetMessageInitial extends GetMessageState {}

class GetMessageLoaded extends GetMessageState {
  Stream<List<MessageModel>> data;

  GetMessageLoaded({required this.data});
}

class GetMessageError extends GetMessageState {}
