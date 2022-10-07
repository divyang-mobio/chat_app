import 'package:bloc/bloc.dart';
import '../../utils/firebase_auth.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseAuthService firebaseAuthService;

  LoginBloc({required this.firebaseAuthService}) : super(LoginInitial()) {
    on<SignIn>(_signIn);
    on<SignUp>(_signUp);
    on<LogOut>(_logout);
  }

  void _signIn(SignIn event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await firebaseAuthService.signInUser(
          email: event.email, password: event.password);
      emit(LoginSuccess());
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }

  void _signUp(SignUp event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await firebaseAuthService.signUpUser(
          name: event.name, email: event.email, password: event.password);
      emit(LoginSuccess());
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }

  void _logout(LogOut event, Emitter<LoginState> emit) async {
    try {
      await firebaseAuthService.logOut();
      emit(LogOutSuccess());
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }
}
