import 'package:bloc/bloc.dart';
import '../../utils/firestore_service.dart';

import '../../models/group_model.dart';
import '../../utils/shared_data.dart';

part 'get_group_event.dart';

part 'get_group_state.dart';

class GetGroupBloc extends Bloc<GetGroupEvent, GetGroupState> {
  GetGroupBloc() : super(GetGroupInitial()) {
    on<GetGroupsId>((event, emit) async {
      emit(GetGroupLoaded(
          groupData: DatabaseService(uid: await PreferenceServices().getUid())
              .getAllGroup()));
    });
  }
}
