part of 'speech_to_text_bloc.dart';

abstract class SpeechToTextState {}

class SpeechToTextInitial extends SpeechToTextState {}

class SpeechToTextStateListening extends SpeechToTextState {
  bool isListening;

  SpeechToTextStateListening({required this.isListening});
}
