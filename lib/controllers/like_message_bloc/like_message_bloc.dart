import 'package:bloc/bloc.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:chat_app/utils/firestore_service.dart';
import 'package:chat_app/utils/shared_data.dart';

part 'like_message_event.dart';

part 'like_message_state.dart';

class LikeMessageBloc extends Bloc<LikeMessageEvent, LikeMessageState> {
  LikeMessageBloc() : super(LikeMessageInitial()) {
    on<LikeMessageData>((event, emit) async {
      String uid = await PreferenceServices().getUid();
      String name = await PreferenceServices().getAdmin();
      String phone = await PreferenceServices().getPhone();
      if (name == '') {
        name = phone;
      }
      int? index = event.messageModel.like
          ?.indexWhere((element) => element.id == '${uid}_$name', 0);

      DatabaseService().likeMessage(
          messageModel: event.messageModel,
          index: index ?? -1,
          id: event.id,
          otherId: event.messageModel.id,
          uid: '${uid}_$name',
          type: event.type,
          isGroup: event.isGroup,
          isDelete: false);
    });

    on<DeleteLikeMessageData>((event, emit) async {
      String uid = await PreferenceServices().getUid();
      String name = await PreferenceServices().getAdmin();
      String phone = await PreferenceServices().getPhone();
      if (name == '') {
        name = phone;
      }
      int? index = event.messageModel.like
          ?.indexWhere((element) => element.id == '${uid}_$name', 0);

      DatabaseService().likeMessage(
          isDelete: true,
          messageModel: event.messageModel,
          index: index ?? -1,
          id: event.id,
          otherId: event.messageModel.id,
          uid: '${uid}_$name',
          type: ReactionType.happy,
          isGroup: event.isGroup);
    });
  }
}
