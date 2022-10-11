import 'package:chat_app/controllers/chat_bloc/chat_bloc.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../widgets/chat_screen_widgets.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.userModel.name)),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatInitial) {
              return Column(
                children: [
                  Expanded(
                      child: Container(
                    child: showMessage(),
                  )),
                  NewMessageSend(otherId: widget.userModel.uid)
                ],
              );
            } else if (state is HaveID) {
              return Column(
                children: [
                  Expanded(
                      child: Container(
                    child: showMessage(id: state.id),
                  )),
                  NewMessageSend(otherId: widget.userModel.uid, id: state.id)
                ],
              );
            } else {
              return Center(child: Text(TextResources().blocError));
            }
          },
        ));
  }
}
