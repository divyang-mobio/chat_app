import 'package:bloc/bloc.dart';
import "../../models/user_model.dart";
import '../../utils/firestore_service.dart';
import '../../utils/shared_data.dart';

part 'send_group_data_event.dart';

part 'send_group_data_state.dart';

class SendGroupDataBloc extends Bloc<SendGroupDataEvent, SendGroupDataState> {
  SendGroupDataBloc() : super(SendGroupDataInitial()) {
    on<GiveGroupData>((event, emit) async {
      emit(SendGroupDataLoading());
      try {
        List<String> ids = event.data.map((e) => e.uid).toList();
        DatabaseService().createGroup(
            uid: ids,
            groupName: event.groupName,
            url: event.url,
            adminUid: await PreferenceServices().getUid());
        emit(SendGroupDataSuccess());
      } catch (e) {
        emit(SendGroupDataError());
      }
    });
  }
}
