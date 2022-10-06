import '../controllers/login_Bloc/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/main_screen_widget.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';

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
        if (state is LoginError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(AppTitle().mainScreen), actions: [popupMenuButton()]),
        body: Center(
            child: Text((RepositoryProvider.of<FirebaseAuth>(context)
                    .currentUser
                    ?.displayName)
                .toString())),
      ),
    );
  }
}
