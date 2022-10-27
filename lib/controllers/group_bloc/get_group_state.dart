part of 'get_group_bloc.dart';

abstract class GetGroupState {}

class GetGroupInitial extends GetGroupState {}

class GetGroupLoaded extends GetGroupState {
  Stream<List<GroupModel>> groupData;

  GetGroupLoaded({required this.groupData});
  }

class GetGroupError extends GetGroupState {}
