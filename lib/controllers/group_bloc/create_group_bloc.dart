import 'package:bloc/bloc.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utils/firestore_service.dart';

part 'create_group_event.dart';

part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc() : super(CreateGroupInitial()) {
    on<GetGroupData>((event, emit) {
      try {
        emit(CreateGroupLoaded(
            data: DatabaseService(uid: event.uid).getAllUserDataForGroup()));
      } catch (e) {
        emit(CreateGroupError());
      }
    });
  }
}