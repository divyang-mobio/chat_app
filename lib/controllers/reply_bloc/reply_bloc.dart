import 'package:bloc/bloc.dart';

import '../../models/message_model.dart';

part 'reply_event.dart';

part 'reply_state.dart';

class ReplyBloc extends Bloc<ReplyEvent, ReplyState> {
  ReplyBloc() : super(ReplyInitial()) {
    on<ReplyMessage>((event, emit) {
      emit(ReplyMessageData(messageModel: event.messageModel));
    });
    on<CancelReply>((event, emit) {
      emit(ReplyInitial());
    });
  }
}
