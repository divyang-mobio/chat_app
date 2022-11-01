import 'package:bloc/bloc.dart';

part 'speech_to_text_event.dart';

part 'speech_to_text_state.dart';

class SpeechToTextBloc extends Bloc<SpeechToTextEvent, SpeechToTextState> {
  SpeechToTextBloc() : super(SpeechToTextInitial()) {
    on<IsListening>((event, emit) {
      emit(SpeechToTextStateListening(isListening: event.isListening));
    });
  }
}
