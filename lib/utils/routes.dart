import '../screens/new_chat_screen.dart';
import '../screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../screens/signIn_screen.dart';
import 'redirect_class.dart';

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
      case '/newContact':
        return MaterialPageRoute(
            builder: (context) => const SelectContactScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => const RegistrationScreen());
    }
  }
}
