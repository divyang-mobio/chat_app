part of 'edit_text_bloc.dart';

abstract class EditTextState {}

class EditTextInitial extends EditTextState {}

class EnterText extends EditTextState {
  MessageModel messageModel;
  String id;

  EnterText({required this.messageModel, required this.id});
}

class EditTextError extends EditTextState {}
