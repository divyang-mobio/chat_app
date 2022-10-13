import 'package:bloc/bloc.dart';

part 'refresh_event.dart';
part 'refresh_state.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  RefreshBloc() : super(RefreshInitial()) {
    on<RefreshVideo>((event, emit) {
      emit(RefreshLoaded());
    });
  }
}
