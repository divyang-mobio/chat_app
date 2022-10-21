part of 'send_group_data_bloc.dart';

abstract class SendGroupDataState {}

class SendGroupDataInitial extends SendGroupDataState {}

class SendGroupDataLoading extends SendGroupDataState {}

class SendGroupDataSuccess extends SendGroupDataState {}

class SendGroupDataError extends SendGroupDataState {}
