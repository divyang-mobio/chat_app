part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class OtpSuccess extends LoginState {}

class LogOutSuccess extends LoginState {}

class LoginError extends LoginState {
  String error;

  LoginError({required this.error});
}
