import '../controllers/chat_list/chat_list_bloc.dart';
import '../controllers/chat_list/get_user_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/message_model.dart';
import '../utils/shared_data.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../widgets/common_widgets_of_chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  String uid = "";

  void callUserData() async {
    uid = await PreferenceServices().getUid();
  }

  BlocBuilder listBloc() {
    return BlocBuilder<GetUserDataBloc, GetUserDataState>(
      builder: (context, state) {
        if (state is GetUserDataInitial) {
          return shimmerLoading();
        } else if (state is GetUserDataLoaded) {
          return userModelStream(context,
              data: state.chatData, isChatScreen: true);
        } else {
          return Center(child: Text(TextResources().noOneFroChat));
        }
      },
    );
  }

  BlocBuilder chatBody() {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state is ChatListInitial) {
          return shimmerLoading();
        } else if (state is ChatListLoaded) {
          return StreamBuilder<List<MessageDetailModel>>(
              stream: state.chatData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return shimmerLoading();
                } else {
                  if (snapshot.data != null) {
                    List<String>? data = snapshot.data
                        ?.map(
                            (e) => e.id.replaceAll(uid, "").replaceAll("_", ""))
                        .toList();
                    if (data != null && data != []) {
                      BlocProvider.of<GetUserDataBloc>(context)
                          .add(GetUserModel(data: data));
                      return listBloc();
                    } else {
                      return Center(child: Text(TextResources().noOneFroChat));
                    }
                  } else {
                    return Center(child: Text(TextResources().noOneFroChat));
                  }
                }
              });
        } else if (state is ChatListError) {
          return Center(child: Text(TextResources().error));
        } else {
          return Center(child: Text(TextResources().blocError));
        }
      },
    );
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return chatBody();
  }
}
