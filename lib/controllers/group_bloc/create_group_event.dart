part of 'create_group_bloc.dart';

abstract class CreateGroupEvent {}

class GetGroupData extends CreateGroupEvent {
  String uid;

  GetGroupData({required this.uid});
}
