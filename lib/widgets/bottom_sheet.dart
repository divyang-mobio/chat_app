import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/chat_bloc/chat_bloc.dart';

bottomSheet(contexts, {required String otherUid}) {
  if (Platform.isIOS) {
    return showModalBottomSheet(
        context: contexts,
        builder: (BuildContext context) {
          return CupertinoPageScaffold(
            child: CupertinoActionSheet(
                actions: BottomSheetList()
                    .getBottomSheetData()
                    .map(
                      (data) => CupertinoActionSheetAction(
                        onPressed: () {
                          BlocProvider.of<ChatBloc>(context).add(
                              SendTypeMessage(
                                  context: contexts,
                                  otherUid: otherUid,
                                  type: data.type,
                                  imageSource: data.imageSource,
                                  isVideo: data.isVideo));
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
                  children: BottomSheetList()
                      .getBottomSheetData()
                      .map((e) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<ChatBloc>(context).add(
                                SendTypeMessage(
                                    context: contexts,
                                    otherUid: otherUid,
                                    type: e.type,
                                    imageSource: e.imageSource,
                                    isVideo: e.isVideo));
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
