import 'package:bloc/bloc.dart';
import '../../utils/shared_data.dart';
import '../../utils/firestore_service.dart';

part 'update_profile_event.dart';

part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(UpdateProfileInitial()) {
    on<UpdateProfile>((event, emit) async {
      try {
        emit(UpdateProfileLoading());
        await DatabaseService(uid: await PreferenceServices().getUid())
            .updateProfile(name: event.name, pic: event.url);
        PreferenceServices().setPic(profilePic: event.url);
        PreferenceServices().setName(name: event.name);
        emit(UpdateProfileLoaded());
      } catch (e) {
        emit(UpdateProfileError());
        emit(UpdateProfileInitial());
      }
    });
  }
}
