import 'package:chat_app/controllers/group_bloc/user_detail_bloc.dart';
import 'package:chat_app/models/group_model.dart';
import 'package:chat_app/utils/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../resources/resource.dart';
import '../widgets/common_widgets_of_chat_screen.dart';
import '../widgets/login_screens_widget.dart';
import '../widgets/network_image.dart';
import '../widgets/regitration_screen_widgets.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.groupModel}) : super(key: key);

  final GroupModel groupModel;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Info'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: showProfilePic(
                  onTap: () {},
                  child: (widget.groupModel.image == "")
                      ? ClipOval(
                          child: Image.asset(ImagePath().noImageImagePath))
                      : ClipOval(
                          child: SizedBox.fromSize(
                          size: const Size.fromRadius(60),
                          child: networkImages(link: widget.groupModel.image),
                        ))),
            ),
            Text(widget.groupModel.groupName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25)),
            Text('${widget.groupModel.persons.length} participants'),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('participants',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              ),
            ),
            BlocBuilder<UserDetailBloc, UserDetailState>(
                builder: (context, state) {
              if (state is UserDetailInitial) {
                return shimmerLoading(length: 4);
              } else if (state is UserDetailLoaded) {
                return userModelStream(context,
                    data: state.userDetail,
                    isChatScreen: true,
                    groupId: widget.groupModel.id,
                    isAdmin: widget.groupModel.admin.contains(state.id),
                    adminList: widget.groupModel.admin);
              } else {
                return Center(child: Text(TextResources().noOneFroChat));
              }
            }),
            const SizedBox(height: 10),
            floatingActionButton(context, onPressed: () async {
              BlocProvider.of<UserDetailBloc>(context).add(RemoveExitGroup(
                  userId: await PreferenceServices().getUid(),
                  groupId: widget.groupModel.id));
              Navigator.of(context)
                ..pop()
                ..pop();
            }, widget: const Text('Exit Group'), color: Colors.red),
          ]),
        ),
      ),
    );
  }
}
