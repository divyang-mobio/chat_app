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

class _MainScreenState extends State<MainScreen> {
  void callUserData() {
    String email =
        (RepositoryProvider.of<FirebaseAuth>(context).currentUser?.email)
            .toString();
    BlocProvider.of<NewContactBloc>(context)
        .add(GetNewContactData(email: email));
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

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
        body: BlocBuilder<NewContactBloc, NewContactState>(
          builder: (context, state) {
            if (state is NewContactInitial) {
              return Shimmer.fromColors(
                  baseColor: ColorResources().shimmerBase,
                  highlightColor: ColorResources().shimmerHighlight,
                  child: listView(userData: [], isLoading: true));
            } else if (state is NewContactLoaded) {
              return listView(userData: state.newContactData, isLoading: false);
            } else if (state is NewContactError) {
              return Center(child: Text(TextResources().error));
            } else {
              return Center(child: Text(TextResources().blocError));
            }
          },
        ),
      ),
    );
  }
}
