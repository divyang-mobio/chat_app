import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/chat_bloc/chat_bloc.dart';
import '../models/message_model.dart';
import '../resources/resource.dart';
import '../utils/firestore_service.dart';

showMessage({String? id}) {
  return (id == null)
      ? Container()
      : BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return StreamBuilder<List<MessageModel>>(
                stream: DatabaseService().getMessages(id: id),
                builder: (context, snapshot) {
                  final message = snapshot.data;
                  return message == null
                      ? Container()
                      : ListView.builder(
                          reverse: true,
                          itemCount: message.length,
                          itemBuilder: (context, index) {
                            return (message[index].name ==
                                    (RepositoryProvider.of<FirebaseAuth>(
                                                context)
                                            .currentUser
                                            ?.displayName)
                                        .toString())
                                ? showMessageWidget(context,
                                    message: message[index], isMe: true)
                                : showMessageWidget(context,
                                    message: message[index], isMe: false);
                          },
                        );
                });
          },
        );
}

showMessageWidget(context,
    {required MessageModel message, required bool isMe}) {
  return Row(
    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isMe
                ? ColorResources().chatBubbleYourSideBG
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(isMe ? 10 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 10)),
            border: Border.all(color: ColorResources().chatBubbleBorder)),
        child: Text(message.message,
            style: TextStyle(
                color: isMe
                    ? ColorResources().chatBubbleYourSideText
                    : ColorResources().chatBubbleOtherSideText)),
      )
    ],
  );
}

class NewMessageSend extends StatefulWidget {
  const NewMessageSend({Key? key, required this.otherId, this.id})
      : super(key: key);
  final String otherId;
  final String? id;

  @override
  State<NewMessageSend> createState() => _NewMessageSendState();
}

class _NewMessageSendState extends State<NewMessageSend> {
  final TextEditingController _controller = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    BlocProvider.of<ChatBloc>(context).add(SendMessage(
        name: (RepositoryProvider.of<FirebaseAuth>(context)
                .currentUser
                ?.displayName)
            .toString(),
        context: context,
        message: _controller.text.trim(),
        otherUid: widget.otherId,
        yourUid: (RepositoryProvider.of<FirebaseAuth>(context).currentUser?.uid)
            .toString()));
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
      child: Row(children: [
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
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _controller.text.trim() == '' ? null : sendMessage(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Theme.of(context).primaryColor),
            child: Icon(IconResources().sendMessage,
                color: ColorResources().sendMessageIcon),
          ),
        )
      ]),
    );
  }
}
