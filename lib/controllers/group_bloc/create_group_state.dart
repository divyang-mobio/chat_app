part of 'create_group_bloc.dart';

abstract class CreateGroupState {}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupLoaded extends CreateGroupState {
  Stream<List<UserModel>> data;

  CreateGroupLoaded({required this.data});
}

class CreateGroupError extends CreateGroupState {}
