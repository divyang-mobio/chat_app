part of 'speech_to_text_bloc.dart';

abstract class SpeechToTextEvent {}

class IsListening extends SpeechToTextEvent {
  bool isListening;

  IsListening({required this.isListening});
}
