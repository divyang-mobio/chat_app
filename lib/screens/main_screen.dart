import 'package:chat_app/controllers/login_Bloc/login_bloc.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogOutSuccess) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegistrationScreen()));
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(AppTitle().mainScreen), actions: [popupMenuButton()]),
        body: Container(),
      ),
    );
  }
}

PopupMenuButton popupMenuButton() {
  return PopupMenuButton(
    itemBuilder: (context) => ListResources()
        .getPopUpData(context)
        .map(
          (e) => PopupMenuItem(
            onTap: e.onPressed,
            child: Row(
              children: [
                Icon(e.iconData),
                const SizedBox(width: 10),
                Text(e.title)
              ],
            ),
          ),
        )
        .toList(),
    elevation: 2,
  );
}
