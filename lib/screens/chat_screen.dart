import 'package:chat_app/controllers/chat_bloc/chat_bloc.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/show_Status_bloc/show_status_bloc.dart';
import '../models/user_model.dart';
import '../widgets/chat_screen_widgets.dart';
import '../widgets/network_image.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  getChatId() {
    BlocProvider.of<ChatBloc>(context).add(GetId(
        otherUid: widget.userModel.uid,
        yourUid: (RepositoryProvider.of<FirebaseAuth>(context).currentUser?.uid)
            .toString()));
  }

  @override
  void initState() {
    getChatId();
    BlocProvider.of<ShowStatusBloc>(context)
        .add(ShowStatus(id: widget.userModel.uid));
    super.initState();
  }

  BlocBuilder checkStatus() {
    return BlocBuilder<ShowStatusBloc, ShowStatusState>(
      builder: (context, state) {
        if (state is ShowStatusLoaded) {
          return StreamBuilder<List<UserModel>>(
              stream: state.status,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Text(snapshot.data![0].status
                      ? TextResources().onlineStatue
                      : TextResources().offlineStatue);
                } else {
                  return const Text('');
                }
              });
        } else {
          return const Text('');
        }
      },
    );
  }

  Column showBody({String? id}) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: showMessage(id: id),
        )),
        NewMessageSend(otherId: widget.userModel.uid, id: id)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources().bgOfAllScreen,
        appBar: AppBar(
            leadingWidth: 25,
            title: ListTile(
              leading: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(20),
                  child: (widget.userModel.profilePic == '')
                      ? Image.asset(ImagePath().noImageImagePath)
                      : networkImages(link: widget.userModel.profilePic),
                ),
              ),
              title: Text(
                  (widget.userModel.name == "")
                      ? widget.userModel.phone
                      : widget.userModel.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: checkStatus(),
              textColor: ColorResources().appBarIconTextColor,
            )),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatInitial) {
              return showBody();
            } else if (state is HaveID) {
              return showBody(id: state.id);
            } else {
              return Center(child: Text(TextResources().blocError));
            }
          },
        ));
  }
}
