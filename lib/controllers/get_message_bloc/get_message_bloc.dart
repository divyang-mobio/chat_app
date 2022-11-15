import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/models/message_model.dart';

import '../../utils/firestore_service.dart';

part 'get_message_event.dart';

part 'get_message_state.dart';

class GetMessageBloc extends Bloc<GetMessageEvent, GetMessageState> {
  GetMessageBloc() : super(GetMessageInitial()) {
    on<MessageId>((event, emit) {
      emit(GetMessageLoaded(
          data: DatabaseService()
              .getMessages(id: event.id, isGroup: event.isGroup)));
    });
  }
}
