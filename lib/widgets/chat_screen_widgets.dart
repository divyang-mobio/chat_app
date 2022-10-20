import 'package:chat_app/controllers/video_thumbnail_bloc/video_thumbnail_bloc.dart';
import 'package:chat_app/widgets/bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/chat_bloc/chat_bloc.dart';
import '../models/message_model.dart';
import '../resources/resource.dart';
import '../utils/firestore_service.dart';
import '../utils/shared_data.dart';
import 'network_image.dart';

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
                            return (message[index].phone ==
                                    (RepositoryProvider.of<FirebaseAuth>(
                                                context)
                                            .currentUser
                                            ?.phoneNumber)
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

Row showMessageWidget(context,
    {required MessageModel message, required bool isMe}) {
  return Row(
    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      if (isMe) const Flexible(flex: 1, child: SizedBox()),
      Flexible(
        flex: 2,
        child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                        bottomRight: Radius.circular(isMe ? 0 : 10))),
                child: (message.type == SendDataType.text)
                    ? textMessage(isMe: isMe, text: message.message)
                    : (message.type == SendDataType.image)
                        ? networkImages(link: message.message)
                        : BlocProvider<VideoThumbnailBloc>(
                            create: (context) => VideoThumbnailBloc(),
                            child: VideoThumbNail(link: message.message),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(message.data,
                    style: TextStyle(color: ColorResources().chatScreenDate)),
              ),
            ]),
      ),
      if (!isMe) const Flexible(flex: 1, child: SizedBox()),
    ],
  );
}

Text textMessage({required String text, required bool isMe}) {
  return Text(text,
      style: TextStyle(
          color: isMe
              ? ColorResources().chatBubbleYourSideText
              : ColorResources().chatBubbleOtherSideText));
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
        name: await PreferenceServices().getAdmin(),
        context: context,
        message: _controller.text.trim(),
        otherUid: widget.otherId,
        yourUid: await PreferenceServices().getUid(),
        type: SendDataType.text,
        phone: await PreferenceServices().getPhone()));
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconButton addFilePrefix() {
    return IconButton(
        onPressed: () {
          bottomSheet(context, otherUid: widget.otherId);
        },
        icon: Icon(IconResources().addOtherTypeOfMessage,
            color: ColorResources().textFieldIcon));
  }

  TextField textField() {
    return TextField(
      controller: _controller,
      minLines: 1,
      maxLines: 500,
      textCapitalization: TextCapitalization.sentences,
      autocorrect: true,
      enableSuggestions: true,
      decoration: InputDecoration(
        prefixIcon: addFilePrefix(),
        suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(IconResources().micFromSpeechToText,
                color: ColorResources().textFieldIcon)),
        filled: true,
        fillColor: ColorResources().sendMessageTextField,
        hintText: TextResources().sendMessageTextFieldHintText,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.grey),
            gapPadding: 10,
            borderRadius: BorderRadius.circular(25)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0, color: Colors.grey),
            gapPadding: 10,
            borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  GestureDetector sendButton() {
    return GestureDetector(
      onTap: () => _controller.text.trim() == '' ? null : sendMessage(),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 25,
        child: Icon(IconResources().sendMessage,
            color: ColorResources().sendMessageIcon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Expanded(child: textField()),
        const SizedBox(width: 10),
        sendButton()
      ]),
    );
  }
}
