import '../screens/main_screen.dart';
import '../screens/signIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Error")));
            return const SignInScreen();
          } else {
            return const SignInScreen();
          }
        });
  }
}
