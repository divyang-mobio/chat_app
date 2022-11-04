import 'package:bloc/bloc.dart';
import 'package:chat_app/models/status_model.dart';
import 'package:chat_app/utils/firestore_service.dart';

part 'get_status_event.dart';

part 'get_status_state.dart';

class GetStatusBloc extends Bloc<GetStatusEvent, GetStatusState> {
  GetStatusBloc() : super(GetStatusInitial()) {
    on<GetStatusData>((event, emit) {
      emit(GetStatusLoaded(data: DatabaseService().getStatus()));
    });
  }
}
