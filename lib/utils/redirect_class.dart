import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/signIn_screen.dart';
import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../resources/resource.dart';

class RedirectClass extends StatefulWidget {
  const RedirectClass({Key? key}) : super(key: key);

  @override
  State<RedirectClass> createState() => _RedirectClassState();
}

class _RedirectClassState extends State<RedirectClass> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: RepositoryProvider.of<FirebaseAuth>(context).authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(TextResources().redirectScreenError)));
            return const SignInScreen();
          } else {
            return const SignInScreen();
          }
        });
  }
}
