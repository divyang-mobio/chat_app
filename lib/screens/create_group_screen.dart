import 'package:chat_app/resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/group_bloc/create_group_bloc.dart';
import '../utils/shared_data.dart';
import '../widgets/common_widgets_of_chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTitle().createGroupScreen),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
          IconButton(
              onPressed: () {}, icon: Icon(IconResources().navigateForward))
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
    );
  }
}
