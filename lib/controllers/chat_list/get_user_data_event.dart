part of 'get_user_data_bloc.dart';

abstract class GetUserDataEvent {}

class GetUserModel extends GetUserDataEvent {
  List<String> data;

  GetUserModel({required this.data});
}
