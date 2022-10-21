part of 'add_data_group_bloc.dart';

abstract class AddDataGroupState {}

class AddDataGroupInitial extends AddDataGroupState {}

class AddDataGroupLoading extends AddDataGroupState {
  List<UserModel> data;

  AddDataGroupLoading({required this.data});
}

class AddDataGroupError extends AddDataGroupState {}
