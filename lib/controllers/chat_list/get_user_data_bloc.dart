import 'package:bloc/bloc.dart';

import '../../models/user_model.dart';
import '../../utils/firestore_service.dart';

part 'get_user_data_event.dart';

part 'get_user_data_state.dart';

class GetUserDataBloc extends Bloc<GetUserDataEvent, GetUserDataState> {
  GetUserDataBloc() : super(GetUserDataInitial()) {
    on<GetUserModel>((event, emit) {
      try {
        emit(GetUserDataLoaded(
            chatData: DatabaseService().getUserModelFromIdList(event.data)));
      } catch (e) {
        emit(GetUserDataError());
      }
    });
  }
}
