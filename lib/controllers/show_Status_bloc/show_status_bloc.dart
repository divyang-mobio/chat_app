import 'package:bloc/bloc.dart';
import 'package:chat_app/models/user_model.dart';

import '../../utils/firestore_service.dart';

part 'show_status_event.dart';

part 'show_status_state.dart';

class ShowStatusBloc extends Bloc<ShowStatusEvent, ShowStatusState> {
  ShowStatusBloc() : super(ShowStatusInitial()) {
    on<ShowStatus>((event, emit) {
      emit(ShowStatusLoaded(
          status: DatabaseService(uid: event.id).checkIndividualStatus()));
    });
  }
}
