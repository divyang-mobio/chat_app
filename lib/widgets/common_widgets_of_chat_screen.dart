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

MediaQuery userModelStream(context, {required Stream<List<UserModel>> data}) {
  return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: StreamBuilder<List<UserModel>>(
          stream: data,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data != []) {
              return listView(
                  userData: snapshot.data as List<UserModel>, isLoading: false);
            } else {
              return shimmerLoading();
            }
          }));
}

Shimmer shimmerLoading() {
  return Shimmer.fromColors(
      baseColor: ColorResources().shimmerBase,
      highlightColor: ColorResources().shimmerHighlight,
      child: listView(userData: [], isLoading: true));
}
