part of 'show_status_bloc.dart';

abstract class ShowStatusState {}

class ShowStatusInitial extends ShowStatusState {}

class ShowStatusLoaded extends ShowStatusState {
  Stream<List<UserModel>> status;

  ShowStatusLoaded({required this.status});
}

class ShowStatusError extends ShowStatusState {}
