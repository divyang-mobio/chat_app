import 'package:bloc/bloc.dart';
import 'package:chat_app/utils/firestore_service.dart';
import '../../models/user_model.dart';

part 'new_contact_event.dart';

part 'new_contact_state.dart';

class NewContactBloc extends Bloc<NewContactEvent, NewContactState> {
  NewContactBloc() : super(NewContactInitial()) {
    on<GetNewContactData>((event, emit) async {
      try {
        List<UserModel> newContactData =
            await DatabaseService().getAllUserData(email: event.email);
        emit(NewContactLoaded(newContactData: newContactData));
      } catch (e) {
        emit(NewContactError());
      }
    });
  }
}
