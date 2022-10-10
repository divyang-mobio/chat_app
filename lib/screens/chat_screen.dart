import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/resources/resource.dart';
import 'package:chat_app/utils/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? id;

  getChatId() async {
    id = await DatabaseService().getId(
        yourName:
            (RepositoryProvider.of<FirebaseAuth>(context).currentUser?.uid)
                .toString(),
        otherName: widget.userModel.uid);
    setState(() {});
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
        body: Column(
          children: [
            Expanded(
                child: Container(
              child: showMessage(id: id),
            )),
            NewMessageSend(id: widget.userModel.uid)
          ],
        ));
  }
}

showMessage({String? id}) {
  return (id == null)
      ? const Text("No data")
      : StreamBuilder<List<MessageModel>>(
          stream: DatabaseService().getMessages(id: id),
          builder: (context, snapshot) {
            final message = snapshot.data;
            return message == null
                ? const Text('No Messages')
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemCount: message.length,
                    itemBuilder: (context, index) {
                      return (message[index].name ==
                              (RepositoryProvider.of<FirebaseAuth>(context)
                                      .currentUser
                                      ?.uid)
                                  .toString())
                          ? showMessageWidget(context,
                              message: message[index].message, isMe: true)
                          : showMessageWidget(context,
                              message: message[index].message, isMe: false);
                    },
                  );
          });
}

showMessageWidget(context, {required String message, required bool isMe}) {
  return Row(
    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isMe ? Colors.white : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20)),
            border: Border.all(color: Colors.black)),
        child: Text(message),
      )
    ],
  );
}

class NewMessageSend extends StatefulWidget {
  const NewMessageSend({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<NewMessageSend> createState() => _NewMessageSendState();
}

class _NewMessageSendState extends State<NewMessageSend> {
  final TextEditingController _controller = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    await DatabaseService().sendMessage(
        message: _controller.text.trim(),
        yourName:
            (RepositoryProvider.of<FirebaseAuth>(context).currentUser?.uid)
                .toString(),
        otherName: widget.id);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 500,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorResources().sendMessageTextField,
                hintText: TextResources().sendMessageTextFieldHintText,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              _controller.text.trim() == '' ? null : sendMessage();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor),
              child: Icon(IconResources().sendMessage,
                  color: ColorResources().sendMessageIcon),
            ),
          ),
        ],
      ),
    );
  }
}
