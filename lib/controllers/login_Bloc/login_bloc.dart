import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseAuth auth;

  LoginBloc({required this.auth}) : super(LoginInitial()) {
    on<SignIn>(_signIn);
    on<SignUp>(_signUp);
    on<LogOut>(_logout);
  }

  void _signIn(SignIn event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await auth.signInWithEmailAndPassword(
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
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);

      await result.user?.updateDisplayName(event.name);
      emit(LoginSuccess());
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }

  void _logout(LogOut event, Emitter<LoginState> emit) async {
    try {
      await auth.signOut();
      emit(LogOutSuccess());
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(error: e.toString()));
      emit(LoginInitial());
    }
  }
}
