import 'package:bloc/bloc.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../utils/firestore_service.dart';
import '../../utils/shared_data.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(ChatListInitial()) {
    on<GetChatList>((event, emit) async {
      try {
        emit(ChatListLoaded(
            chatData: DatabaseService()
                .getUserChatList(yourId: await PreferenceServices().getUid())));
      } catch (e) {
        emit(ChatListError());
      }
    });
  }
}
