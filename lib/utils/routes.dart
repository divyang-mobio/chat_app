import 'package:flutter/material.dart';
import '../screens/registration_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const RegistrationScreen());
      default:
        return MaterialPageRoute(builder: (context) => const RegistrationScreen());
    }
  }
}
