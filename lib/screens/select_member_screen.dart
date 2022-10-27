import 'package:chat_app/controllers/group_bloc/add_data_group_bloc.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/group_bloc/create_group_bloc.dart';
import '../models/user_model.dart';
import '../utils/shared_data.dart';
import '../widgets/common_widgets_of_chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  List<UserModel>? data;

  void callUserData() async {
    String uid = await PreferenceServices().getUid();
    callBloc(uid);
  }

  callBloc(String uid) {
    BlocProvider.of<CreateGroupBloc>(context).add(GetGroupData(uid: uid));
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddDataGroupBloc, AddDataGroupState>(
      listener: (context, state) {
        if (state is AddDataGroupLoading) {
          data = state.data;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppTitle().createGroupScreen),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
            IconButton(
                onPressed: () {
                  if (data != null || data != []) {
                    if (data!.length > 2) {
                      Navigator.pushNamed(
                          context, RoutesName().groupRegistrationScreen,
                          arguments: data);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              TextResources().errorWhenSelectGroupMember)));
                    }
                  }
                },
                icon: Icon(IconResources().navigateForward))
          ],
        ),
        body: BlocBuilder<CreateGroupBloc, CreateGroupState>(
          builder: (context, state) {
            if (state is CreateGroupInitial) {
              return shimmerLoading();
            } else if (state is CreateGroupLoaded) {
              return userModelStream(context,
                  data: state.data, isChatScreen: true, isGroupScreen: true);
            } else if (state is CreateGroupError) {
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
