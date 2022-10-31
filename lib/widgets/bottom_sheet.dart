import 'dart:io';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/chat_bloc/chat_bloc.dart';
import '../controllers/group_bloc/user_detail_bloc.dart';
import 'login_screens_widget.dart';

bottomSheet(contexts,
    {required String otherUid, required bool isGroup, String? id}) {
  if (Platform.isIOS) {
    return showModalBottomSheet(
        context: contexts,
        builder: (BuildContext context) {
          return CupertinoPageScaffold(
            child: CupertinoActionSheet(
                actions: getBottomSheetData
                    .map(
                      (data) => CupertinoActionSheetAction(
                        onPressed: () {
                          BlocProvider.of<ChatBloc>(context).add(
                              SendTypeMessage(
                                  id: id,
                                  context: contexts,
                                  otherUid: otherUid,
                                  type: data.type,
                                  imageSource: data.imageSource,
                                  isVideo: data.isVideo,
                                  isGroup: isGroup));
                          Navigator.pop(context);
                        },
                        child: Text(data.title),
                      ),
                    )
                    .toList()),
          );
        });
  } else {
    return showModalBottomSheet(
      context: contexts,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: getBottomSheetData
                      .map((e) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<ChatBloc>(context).add(
                                SendTypeMessage(
                                    id: id,
                                    context: contexts,
                                    otherUid: otherUid,
                                    type: e.type,
                                    imageSource: e.imageSource,
                                    isVideo: e.isVideo,
                                    isGroup: isGroup));
                            Navigator.pop(context);
                          },
                          child: Text(e.title)))
                      .toList()),
            ),
          ),
        );
      },
    );
  }
}

groupBottomSheet(contexts,
    {required UserModel userModel, required String groupId}) {
  if (Platform.isIOS) {
    return showModalBottomSheet(
        context: contexts,
        builder: (BuildContext context) {
          return CupertinoPageScaffold(
            child: CupertinoActionSheet(
                actions: getGroupBottomSheet
                    .map((data) => CupertinoActionSheetAction(
                          onPressed: () {
                            if (data.type == NavigatorType.info) {
                              Navigator.pushNamed(context, RoutesName().chat,
                                  arguments: userModel);
                            } else if (data.type == NavigatorType.admin) {
                              BlocProvider.of<UserDetailBloc>(contexts).add(
                                  MakeAdmin(
                                      userId: userModel.uid, groupId: groupId));
                            } else if (data.type == NavigatorType.remove) {
                              BlocProvider.of<UserDetailBloc>(contexts).add(
                                  RemoveExitGroup(
                                      userId: userModel.uid,
                                      groupId: groupId));
                            }
                          },
                          child: Text(data.title),
                        ))
                    .toList()),
          );
        });
  } else {
    return showModalBottomSheet(
      context: contexts,
      builder: (BuildContext context) {
        return SizedBox(
            height: 200,
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: getGroupBottomSheet
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: floatingActionButton(context, onPressed: () {
                              if (e.type == NavigatorType.info) {
                                Navigator.pushNamed(context, RoutesName().chat,
                                    arguments: userModel);
                              } else if (e.type == NavigatorType.admin) {
                                BlocProvider.of<UserDetailBloc>(contexts).add(
                                    MakeAdmin(
                                        userId: userModel.uid, groupId: groupId));
                              } else if (e.type == NavigatorType.remove) {
                                BlocProvider.of<UserDetailBloc>(contexts).add(
                                    RemoveExitGroup(
                                        userId: userModel.uid,
                                        groupId: groupId));
                              }
                            }, widget: Text(e.title)),
                          ))
                      .toList()),
            )));
      },
    );
  }
}
