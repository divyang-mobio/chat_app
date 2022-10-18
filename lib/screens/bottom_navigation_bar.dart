import 'package:chat_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/login_Bloc/login_bloc.dart';
import '../resources/resource.dart';
import '../utils/firestore_service.dart';
import '../utils/shared_data.dart';
import 'new_contact_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    SelectContactScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void changeStatusFun(bool status) async {
    DatabaseService(uid: await PreferenceServices().getUid())
        .changeStatus(status: status);
  }

  @override
  void initState() {
    changeStatusFun(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      changeStatusFun(true);
    } else {
      changeStatusFun(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogOutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName().redirectRoute, (route) => false);
        }
        if (state is LoginError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: 'Contacts',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
