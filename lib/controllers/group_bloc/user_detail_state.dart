part of 'user_detail_bloc.dart';

abstract class UserDetailState {}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  Stream<List<UserModel>> userDetail;
  String id;

  UserDetailLoaded({required this.userDetail, required this.id});
}

class UserDetailError extends UserDetailState {}
