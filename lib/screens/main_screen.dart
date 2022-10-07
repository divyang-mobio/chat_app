import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/login_Bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../widgets/pop_up_menu.dart';

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
            title: Text(AppTitle().mainScreen,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
              popupMenuButton()
            ]),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (_, index) => const Text('hello'));
            }),
        floatingActionButton: FloatingActionButton(
            backgroundColor: ColorResources().bgFloatingActionButton,
            onPressed: () =>
                Navigator.pushNamed(context, RoutesName().newContact),
            child: Icon(IconResources().floatingActionButtonIcon)),
      ),
    );
  }
}
