import 'package:bloc/bloc.dart';

part 'visible_container_event.dart';

part 'visible_container_state.dart';

class VisibleContainerBloc
    extends Bloc<VisibleContainerEvent, VisibleContainerState> {
  VisibleContainerBloc() : super(VisibleContainerInitial()) {
    on<ShowContainer>((event, emit) {
      emit(VisibleContainerShow(isVis: event.isVis));
    });
  }
}
