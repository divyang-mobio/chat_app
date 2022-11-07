import '../controllers/group_bloc/get_group_bloc.dart';
import 'package:chat_app/widgets/listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/group_model.dart';
import '../resources/resource.dart';
import '../widgets/common_widgets_of_chat_screen.dart';

class GroupDisplayScreen extends StatefulWidget {
  const GroupDisplayScreen({Key? key}) : super(key: key);

  @override
  State<GroupDisplayScreen> createState() => _GroupDisplayScreenState();
}

class _GroupDisplayScreenState extends State<GroupDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetGroupBloc, GetGroupState>(
      builder: (context, state) {
        if (state is GetGroupInitial) {
          return shimmerLoading();
        } else if (state is GetGroupLoaded) {
          return MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: StreamBuilder<List<GroupModel>>(
                stream: state.groupData,
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data != []) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: groupNameListTile(context,
                                  groupModel:
                                      snapshot.data?[index] as GroupModel),
                            ));
                  } else {
                    return shimmerLoading();
                  }
                }),
          );
        } else {
          return Center(child: Text(TextResources().noOneFroChat));
        }
      },
    );
  }
}
