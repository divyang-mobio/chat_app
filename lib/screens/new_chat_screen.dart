import '../controllers/user_bloc/new_contact_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../resources/resource.dart';
import '../widgets/listview.dart';

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
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
    return Scaffold(
      appBar: AppBar(
          title: Text(AppTitle().newContactScreen,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(IconResources().search))
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
    );
  }
}
