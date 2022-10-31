import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/user_model.dart';
import '../resources/resource.dart';
import 'listview.dart';

FlexibleSpaceBar flexibleSpaceBar({required String title}) {
  return FlexibleSpaceBar(
    titlePadding: const EdgeInsets.only(left: 10.0, bottom: 15),
    title: Text(title,
        style: TextStyle(color: ColorResources().appBarIconTextColor)),
  );
}

MediaQuery userModelStream(context,
    {required Stream<List<UserModel>> data,
    required bool isChatScreen,
    List<String> adminList = const [],
    bool isAdmin = false,
    String groupId = '',
    bool isGroupScreen = false}) {
  return MediaQuery.removePadding(
    removeTop: true,
    context: context,
    child: StreamBuilder<List<UserModel>>(
        stream: data,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data != []) {
            return contactBody(context,
                userData: snapshot.data as List<UserModel>,
                isLoading: false,
                isChatScreen: isChatScreen,
                groupId: groupId,
                adminList: adminList,
                isAdmin: isAdmin,
                isGroupScreen: isGroupScreen);
          } else {
            return shimmerLoading();
          }
        }),
  );
}

SingleChildScrollView contactBody(context,
    {required List<UserModel> userData,
    required bool isLoading,
    List<String> adminList = const [],
    String groupId = '',
    bool isAdmin = false,
    required bool isChatScreen,
    bool isGroupScreen = false}) {
  return SingleChildScrollView(
    child: Column(children: [
      if (!isChatScreen)
        GestureDetector(
          onTap: () async {
            Navigator.pushNamed(context, RoutesName().groupContactScreen);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: ColorResources().createGroupButtonBg,
                  radius: 30,
                  child: Icon(IconResources().createGroupButton,
                      color: ColorResources().createGroupButtonIcon)),
              title: Text(TextResources().createGroupButton,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 20)),
            ),
          ),
        ),
      isGroupScreen
          ? groupListViewListView(context, userData: userData)
          : listView(
              userData: userData,
              isLoading: false,
              groupId: groupId,
              isAdmin: isAdmin,
              adminList: adminList)
    ]),
  );
}

Shimmer shimmerLoading({int length = 20}) {
  return Shimmer.fromColors(
      baseColor: ColorResources().shimmerBase,
      highlightColor: ColorResources().shimmerHighlight,
      child: listView(userData: [], isLoading: true, length: length));
}
