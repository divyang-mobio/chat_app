import 'package:bloc/bloc.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/firestore_service.dart';
import '../../utils/shared_data.dart';
import '../../widgets/upload_image.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>((event, emit) async {
      try {
        final name = await PreferenceServices().getAdmin();
        if (event.isGroup) {
          await DatabaseService().sendMessageGroup(
              id: event.id.toString(),
              name: (name == '') ? await PreferenceServices().getPhone() : name,
              message: event.message,
              uid: await PreferenceServices().getUid(),
              type: event.type);
        } else {
          await DatabaseService().sendMessage(
              message: event.message,
              yourName:
                  (name == '') ? await PreferenceServices().getPhone() : name,
              yourId: await PreferenceServices().getUid(),
              ids: event.id,
              type: event.type,
              otherId: event.otherUid);
        }
      } catch (e) {
        ScaffoldMessenger.of(event.context).showSnackBar(
            SnackBar(content: Text(TextResources().errorAtMessageSendTime)));
      }
    });

    on<SendTypeMessage>((event, emit) async {
      uploadImage(event.context,
          imageSource: event.imageSource,
          id: event.id,
          otherUid: event.otherUid,
          isVideo: event.isVideo,
          type: event.type,
          isGroup: event.isGroup);
    });
    on<GetId>((event, emit) async {
      emit(ChatInitial());
      String id = await DatabaseService().getId(
          yourName: await PreferenceServices().getUid(),
          otherName: event.otherUid);
      if (id.isNotEmpty) {
        emit(HaveID(id: id));
      }
    });
  }
}
