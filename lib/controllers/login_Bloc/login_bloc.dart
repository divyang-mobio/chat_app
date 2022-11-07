import 'package:bloc/bloc.dart';
import '../../utils/shared_data.dart';
import '../../utils/firebase_auth.dart';
import '../../utils/firestore_service.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseAuthService firebaseAuth;
  String verificationIDString = '';

  LoginBloc({required this.firebaseAuth}) : super(LoginInitial()) {
    on<GetOtp>(_getOTP);
    on<SignUp>(_signUp);
    on<LogOut>(_logout);
  }

  void _getOTP(GetOtp event, Emitter<LoginState> emit) async {
    try {
      final bool sendOtp = await firebaseAuth.enterPhone(phone: event.phone);
      if (sendOtp) {
        emit(OtpSuccess());
      }
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }

  void _signUp(SignUp event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final bool verifyOtp = await firebaseAuth.enterOtp(otp: event.otp);
      if (verifyOtp) {
        emit(LoginSuccess());
        emit(LoginInitial());
      }
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }

  void _logout(LogOut event, Emitter<LoginState> emit) async {
    try {
      await firebaseAuth.logOut();
      DatabaseService(uid: await PreferenceServices().getUid())
          .changeStatus(status: false);
      await PreferenceServices().reset();
      emit(LogOutSuccess());
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }
}
