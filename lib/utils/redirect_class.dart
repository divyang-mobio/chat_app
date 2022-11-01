import 'package:chat_app/screens/bottom_navigation_bar_screen.dart';
import 'shared_data.dart';
import '../screens/signIn_screen.dart';
import 'package:flutter/material.dart';

class RedirectClass extends StatefulWidget {
  const RedirectClass({Key? key}) : super(key: key);

  @override
  State<RedirectClass> createState() => _RedirectClassState();
}

class _RedirectClassState extends State<RedirectClass> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PreferenceServices().getUid(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == '') {
              return const SignInScreen();
            } else {
              return const BottomNavigationBarScreen();
            }
          } else {
            return const Scaffold(
                body: Center(
                    child: SizedBox(child: CircularProgressIndicator())));
          }
        });
  }
}
