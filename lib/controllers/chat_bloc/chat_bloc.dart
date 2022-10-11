import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../utils/firestore_service.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>((event, emit) async {
      try {
        await DatabaseService().sendMessage(
            message: event.message,
            yourName: event.name,
            yourId: event.yourUid,
            ids: event.id,
            otherId: event.otherUid);
      } catch (e) {
        ScaffoldMessenger.of(event.context)
            .showSnackBar(const SnackBar(content: Text('message not send')));
      }
    });
    on<GetId>((event, emit) async {
      emit(ChatInitial());
      String id = await DatabaseService()
          .getId(yourName: event.yourUid, otherName: event.otherUid);
      emit(HaveID(id: id));
    });
  }
}
