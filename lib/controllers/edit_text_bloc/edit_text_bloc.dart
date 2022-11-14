import 'package:bloc/bloc.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/utils/firestore_service.dart';

part 'edit_text_event.dart';

part 'edit_text_state.dart';

class EditTextBloc extends Bloc<EditTextEvent, EditTextState> {
  EditTextBloc() : super(EditTextInitial()) {
    on<EditText>((event, emit) {
      emit(EnterText(messageModel: event.messageModel, id: event.id));
    });
    on<SendEditText>((event, emit) {
      DatabaseService().editMessage(
          id: event.id,
          otherId: event.otherId,
          isGroup: event.isGroup,
          editMessage: event.message);
      emit(EditTextInitial());
    });
    on<CancelEditText>((event, emit) {
      emit(EditTextInitial());
    });
  }
}
