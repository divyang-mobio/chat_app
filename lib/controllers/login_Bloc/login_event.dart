part of 'login_bloc.dart';

abstract class LoginEvent {}

class SignUp extends LoginEvent {
  String otp;

  SignUp({required this.otp});
}

class GetOtp extends LoginEvent {
  String phone;

  GetOtp({required this.phone});
}

class LogOut extends LoginEvent {}
