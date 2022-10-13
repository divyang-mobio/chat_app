import 'package:bloc/bloc.dart';
import 'package:video_player/video_player.dart';

part 'play_pause_event.dart';

part 'play_pause_state.dart';

class PlayPauseBloc extends Bloc<PlayPauseEvent, PlayPauseState> {
  PlayPauseBloc() : super(PlayPauseInitial()) {
    on<PlayPause>((event, emit) {
      event.controller.value.isPlaying
          ? event.controller.pause()
          : event.controller.play();
      emit(PlayPauseLoaded(isPlay: event.controller.value.isPlaying));
    });
  }
}
