import 'package:bloc/bloc.dart';
import '../../models/user_model.dart';

part 'add_data_group_event.dart';

part 'add_data_group_state.dart';

class AddDataGroupBloc extends Bloc<AddDataGroupEvent, AddDataGroupState> {
  List<UserModel> member = [];

  AddDataGroupBloc() : super(AddDataGroupInitial()) {
    on<AddMember>((event, emit) {
      member.addAll(event.userModel);
      emit(AddDataGroupLoading(data: member));
    });
    on<RemoveMember>((event, emit) {
      member.removeWhere((element) => element.uid == event.userModel.uid);
      emit(AddDataGroupLoading(data: member));
    });
  }
}
