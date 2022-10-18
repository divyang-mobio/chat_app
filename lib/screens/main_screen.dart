import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/resources/shared_data.dart';
import 'package:chat_app/utils/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/login_Bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../controllers/user_bloc/new_contact_bloc.dart';
import '../resources/resource.dart';
import '../widgets/listview.dart';
import '../widgets/pop_up_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  void callUserData() {
    String uid = (RepositoryProvider.of<FirebaseAuth>(context).currentUser?.uid)
        .toString();
    BlocProvider.of<NewContactBloc>(context).add(GetNewContactData(uid: uid));
  }

  Shimmer shimmerLoading() {
    return Shimmer.fromColors(
        baseColor: ColorResources().shimmerBase,
        highlightColor: ColorResources().shimmerHighlight,
        child: listView(userData: [], isLoading: true));
  }

  @override
  void initState() {
    callUserData();
    changeStatusFun(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void changeStatusFun(bool status) {
    DatabaseService(
            uid: RepositoryProvider.of<FirebaseAuth>(context).currentUser?.uid)
        .changeStatus(status: status);
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
        // appBar: AppBar(
        //     title: Text(AppTitle().mainScreen,
        //         style: const TextStyle(fontWeight: FontWeight.bold)),
        //     actions: [
        //       IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
        //       popupMenuButton()
        //     ]),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 10.0, bottom: 15),
                title: Text(AppTitle().mainScreen,
                    style:
                        TextStyle(color: ColorResources().appBarIconTextColor)),
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: Icon(IconResources().search)),
                popupMenuButton()
              ],
              floating: false,
              pinned: true,
            )
          ],
          body: BlocBuilder<NewContactBloc, NewContactState>(
            builder: (context, state) {
              if (state is NewContactInitial) {
                return shimmerLoading();
              } else if (state is NewContactLoaded) {
                return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: StreamBuilder<List<UserModel>>(
                      stream: state.newContactData,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return listView(
                              userData: snapshot.data as List<UserModel>,
                              isLoading: false);
                        } else {
                          return shimmerLoading();
                        }
                      }),
                );
              } else if (state is NewContactError) {
                return Center(child: Text(TextResources().error));
              } else {
                return Center(child: Text(TextResources().blocError));
              }
            },
          ),
        ),
      ),
    );
  }
}
