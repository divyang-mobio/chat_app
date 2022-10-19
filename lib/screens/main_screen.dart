import 'package:chat_app/controllers/chat_list/chat_list_bloc.dart';
import 'package:chat_app/controllers/chat_list/get_user_data_bloc.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/user_bloc/new_contact_bloc.dart';
import '../models/message_model.dart';
import '../utils/firestore_service.dart';
import '../utils/shared_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import '../resources/resource.dart';
import '../widgets/listview.dart';
import '../widgets/pop_up_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  String uid = '';

  void callUserData() async {
    uid = await PreferenceServices().getUid();
    setState(() {});
    callBloc(uid);
  }

  callBloc(String uid) {
    BlocProvider.of<ChatListBloc>(context).add(GetChatList(uid: uid));
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverAppBar(
          expandedHeight: 100,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 10.0, bottom: 15),
            title: Text(AppTitle().mainScreen,
                style: TextStyle(color: ColorResources().appBarIconTextColor)),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
            popupMenuButton()
          ],
          floating: false,
          pinned: true,
        )
      ],
      body: BlocConsumer<ChatListBloc, ChatListState>(
        listener: (context, state) {
          if (state is ChatListLoaded) {}
        },
        builder: (context, state) {
          if (state is ChatListInitial) {
            return shimmerLoading();
          } else if (state is ChatListLoaded) {
            return MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: StreamBuilder<List<MessageDetailModel>>(
                  stream: state.chatData,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      List<String>? data = snapshot.data
                          ?.map((e) =>
                              e.id.replaceAll(uid, "").replaceAll("_", ""))
                          .toList();
                      if (data!.isNotEmpty) {
                        BlocProvider.of<GetUserDataBloc>(context)
                            .add(GetUserModel(data: data));
                        return BlocBuilder<GetUserDataBloc, GetUserDataState>(
                          builder: (context, state) {
                            if (state is GetUserDataInitial) {
                              return shimmerLoading();
                            } else if (state is GetUserDataLoaded) {
                              return MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  child: StreamBuilder<List<UserModel>>(
                                      stream: state.chatData,
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return listView(
                                              userData: snapshot.data
                                                  as List<UserModel>,
                                              isLoading: false);
                                        } else {
                                          return shimmerLoading();
                                        }
                                      }));
                            } else if (state is ChatListError) {
                              return Center(child: Text(TextResources().error));
                            } else {
                              return Center(
                                  child: Text(TextResources().blocError));
                            }
                          },
                        );
                      } else {
                        return const Text('Start Chatting');
                      }
                    } else {
                      return shimmerLoading();
                    }
                  }),
            );
            // } else if (state is ChatListUserModel) {
            //   return MediaQuery.removePadding(
            //       removeTop: true,
            //       context: context,
            //       child: StreamBuilder<List<UserModel>>(
            //           stream: state.chatData,
            //           builder: (context, snapshot) {
            //             if (snapshot.data != null) {
            //               return listView(
            //                   userData: snapshot.data as List<UserModel>,
            //                   isLoading: false);
            //             } else {
            //               return shimmerLoading();
            //             }
            //           }));
          } else if (state is ChatListError) {
            return Center(child: Text(TextResources().error));
          } else {
            return Center(child: Text(TextResources().blocError));
          }
        },
      ),
    );
  }
}
