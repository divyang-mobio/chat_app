import 'package:bloc/bloc.dart';

part 'set_otp_field_event.dart';
part 'set_otp_field_state.dart';

class SetOtpFieldBloc extends Bloc<SetOtpFieldEvent, SetOtpFieldState> {
  SetOtpFieldBloc() : super(SetOtpFieldInitial()) {
    on<SetOtpFieldEvent>((event, emit) {
      emit(SetOtpFieldInitial());
    });
  }
}
