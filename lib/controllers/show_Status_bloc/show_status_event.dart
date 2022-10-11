part of 'show_status_bloc.dart';

abstract class ShowStatusEvent {}

class ShowStatus extends ShowStatusEvent {
  String id;

  ShowStatus({required this.id});
}
