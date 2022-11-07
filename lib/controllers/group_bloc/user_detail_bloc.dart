import 'package:bloc/bloc.dart';
import '../../models/group_model.dart';
import '../../utils/firestore_service.dart';
import '../../utils/shared_data.dart';
import '../../models/user_model.dart';

part 'user_detail_event.dart';

part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  GroupModel groupModel;

  UserDetailBloc({required this.groupModel}) : super(UserDetailInitial()) {
    on<UserIds>((event, emit) async {
      final id = await PreferenceServices().getUid();
      emit(UserDetailLoaded(
          id: id,
          userDetail: DatabaseService().getUserModelFromIdList(event.ids)));
    });

    on<MakeAdmin>((event, emit) async {
      DatabaseService().makeAdmin(event.groupId, event.userId);
      groupModel.admin.add(event.userId);
      final id = await PreferenceServices().getUid();

      emit(UserDetailLoaded(
          id: id,
          userDetail:
              DatabaseService().getUserModelFromIdList(groupModel.persons)));
    });
    on<RemoveExitGroup>((event, emit) async {
      DatabaseService().removeExitGroup(event.groupId, event.userId);
      groupModel.persons.removeWhere((element) => element == event.userId);
      groupModel.admin.removeWhere((element) => element == event.userId);
      final id = await PreferenceServices().getUid();
      emit(UserDetailLoaded(
          id: id,
          userDetail:
              DatabaseService().getUserModelFromIdList(groupModel.persons)));
    });
  }
}
