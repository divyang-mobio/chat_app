import '../controllers/user_bloc/new_contact_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../utils/shared_data.dart';
import '../widgets/common_widgets_of_chat_screen.dart';

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  void callUserData() async {
    String uid = await PreferenceServices().getUid();
    callBloc(uid);
  }

  callBloc(String uid) {
    BlocProvider.of<NewContactBloc>(context).add(GetNewContactData(uid: uid));
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverAppBar(
          expandedHeight: 100,
          flexibleSpace: flexibleSpaceBar(title: AppTitle().newContactScreen),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
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
            return userModelStream(context,
                data: state.newContactData, isChatScreen: false);
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
