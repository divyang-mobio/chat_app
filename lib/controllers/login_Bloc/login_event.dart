part of 'login_bloc.dart';

abstract class LoginEvent {}

class SignUp extends LoginEvent {
  String name, email, password;

  SignUp({required this.name, required this.email, required this.password});
}

class SignIn extends LoginEvent {
  String email, password;

  SignIn({required this.email, required this.password});
}

class LogOut extends LoginEvent {}
