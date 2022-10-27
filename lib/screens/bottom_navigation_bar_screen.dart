import '../controllers/bottom_nav_bloc/bottom_navigation_bloc.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/login_Bloc/login_bloc.dart';
import '../resources/resource.dart';
import '../utils/firestore_service.dart';
import '../utils/shared_data.dart';
import '../widgets/common_widgets_of_chat_screen.dart';
import 'groups_display_screen.dart';
import 'new_contact_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with WidgetsBindingObserver {
  static const List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    GroupDisplayScreen(),
    SelectContactScreen()
  ];

  void _onItemTapped(int index) {
    BlocProvider.of<BottomNavigationBloc>(context)
        .add(OnChangeBar(index: index));
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
      child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          if (state is BottomNavigationInitial) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()));
          } else if (state is BottomNavigationLoaded) {
            return Scaffold(
              backgroundColor: ColorResources().bgOfAllScreen,
              body: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) => [
                            SliverAppBar(
                              expandedHeight: 100,
                              elevation: 0,
                              flexibleSpace: flexibleSpaceBar(
                                  title: appbarModel[state.index].title),
                              actions: appbarModel[state.index].actions,
                              floating: false,
                              pinned: true,
                            )
                          ],
                  body: _widgetOptions.elementAt(state.index)),
              bottomNavigationBar: BottomNavigationBar(
                elevation: 0,
                items: bottomNav
                    .map((e) => BottomNavigationBarItem(
                        icon: Icon(e.iconData), label: e.label))
                    .toList(),
                currentIndex: state.index,
                selectedItemColor: Theme.of(context).primaryColor,
                onTap: _onItemTapped,
              ),
            );
          } else {
            return Scaffold(body: Center(child: Text(TextResources().error)));
          }
        },
      ),
    );
  }
}
