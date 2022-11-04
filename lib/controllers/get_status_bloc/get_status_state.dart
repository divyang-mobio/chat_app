part of 'get_status_bloc.dart';

abstract class GetStatusState {}

class GetStatusInitial extends GetStatusState {}

class GetStatusLoaded extends GetStatusState {
  Stream<List<StatusModel>> data;

  GetStatusLoaded({required this.data});
}

class GetStatusError extends GetStatusState {}
