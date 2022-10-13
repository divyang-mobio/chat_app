part of 'play_pause_bloc.dart';

abstract class PlayPauseEvent {}

class PlayPause extends PlayPauseEvent{
  VideoPlayerController controller;

  PlayPause({required this.controller});
}