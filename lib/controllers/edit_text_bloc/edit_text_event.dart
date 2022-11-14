part of 'edit_text_bloc.dart';

abstract class EditTextEvent {}

class EditText extends EditTextEvent {
  MessageModel messageModel;
  String id;

  EditText({required this.messageModel, required this.id});
}

class SendEditText extends EditTextEvent {
  String id, otherId, message;
  bool isGroup;

  SendEditText(
      {required this.id,
      required this.message,
      required this.isGroup,
      required this.otherId});
}

class CancelEditText extends EditTextEvent {}
