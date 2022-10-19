import 'package:bloc/bloc.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../utils/firestore_service.dart';

part 'chat_list_event.dart';

part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(ChatListInitial()) {
    on<GetChatList>((event, emit) {
      try {
        emit(ChatListLoaded(
            chatData: DatabaseService().getUserChatList(yourId: event.uid)));
      } catch (e) {
        emit(ChatListError());
      }
    });
  }
}
