part of 'get_user_data_bloc.dart';

abstract class GetUserDataState {}

class GetUserDataInitial extends GetUserDataState {}

class GetUserDataLoaded extends GetUserDataState {
  Stream<List<UserModel>> chatData;

  GetUserDataLoaded({required this.chatData});
}

class GetUserDataError extends GetUserDataState {}
