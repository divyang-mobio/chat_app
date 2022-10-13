part of 'play_pause_bloc.dart';

abstract class PlayPauseState {}

class PlayPauseInitial extends PlayPauseState {}

class PlayPauseLoaded extends PlayPauseState {
  bool isPlay;

  PlayPauseLoaded({required this.isPlay});
}
