part of 'add_data_group_bloc.dart';

abstract class AddDataGroupEvent {}

class AddMember extends AddDataGroupEvent {
  List<UserModel> userModel;

  AddMember({required this.userModel});
}

class RemoveMember extends AddDataGroupEvent {
  UserModel userModel;

  RemoveMember({required this.userModel});
}

class AddNameImageMember extends AddDataGroupEvent {}
