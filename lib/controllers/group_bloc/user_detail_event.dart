part of 'user_detail_bloc.dart';

abstract class UserDetailEvent {}

class UserIds extends UserDetailEvent {
  List<String> ids;

  UserIds({required this.ids});
}

class MakeAdmin extends UserDetailEvent {
  String groupId, userId;

  MakeAdmin({required this.userId, required this.groupId});
}

class RemoveExitGroup extends UserDetailEvent {
  String groupId, userId;

  RemoveExitGroup({required this.userId, required this.groupId});
}
