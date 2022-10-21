part of 'send_group_data_bloc.dart';

abstract class SendGroupDataEvent {}

class GiveGroupData extends SendGroupDataEvent {
  List<UserModel> data;
  String url, groupName;

  GiveGroupData(
      {required this.data, required this.url, required this.groupName});
}
