import '../screens/signIn_screen.dart';
import 'redirect_class.dart';
import 'package:flutter/material.dart';
import '../screens/registration_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const RedirectClass());
      case '/signUp':
        return MaterialPageRoute(
            builder: (context) => const RegistrationScreen());
      case '/signIn':
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => const RegistrationScreen());
    }
  }
}
