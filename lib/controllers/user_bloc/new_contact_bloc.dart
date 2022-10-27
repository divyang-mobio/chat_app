import 'package:bloc/bloc.dart';
import 'package:chat_app/utils/firestore_service.dart';
import '../../models/user_model.dart';
import '../../utils/shared_data.dart';

part 'new_contact_event.dart';

part 'new_contact_state.dart';

class NewContactBloc extends Bloc<NewContactEvent, NewContactState> {
  NewContactBloc() : super(NewContactInitial()) {
    on<GetNewContactData>((event, emit) async {
      try {
        emit(NewContactLoaded(
            newContactData: DatabaseService(uid: await PreferenceServices().getUid()).getAllUserData()));
      } catch (e) {
        emit(NewContactError());
      }
    });
  }
}
