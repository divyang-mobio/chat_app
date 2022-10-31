import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app/widgets/text_to_speech_widget.dart';

import '../controllers/speect_to_text_bloc/speech_to_text_bloc.dart';
import '../controllers/video_thumbnail_bloc/video_thumbnail_bloc.dart';
import 'bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/chat_bloc/chat_bloc.dart';
import '../models/message_model.dart';
import '../resources/resource.dart';
import '../utils/firestore_service.dart';
import 'network_image.dart';

showMessage({String? id, required bool isGroup}) {
  return (id == null)
      ? Container()
      : StreamBuilder<List<MessageModel>>(
          stream: DatabaseService().getMessages(id: id, isGroup: isGroup),
          builder: (context, snapshot) {
            final message = snapshot.data;
            return message == null
                ? Container()
                : ListView.builder(
                    reverse: true,
                    itemCount: message.length,
                    itemBuilder: (context, index) {
                      return (message[index].uid ==
                              (RepositoryProvider.of<FirebaseAuth>(context)
                                      .currentUser
                                      ?.uid)
                                  .toString())
                          ? showMessageWidget(context,
                              message: message[index],
                              isMe: true,
                              isGroup: isGroup)
                          : showMessageWidget(context,
                              message: message[index],
                              isMe: false,
                              isGroup: isGroup);
                    },
                  );
          },
        );
}

Row showMessageWidget(context,
    {required MessageModel message,
    required bool isMe,
    required bool isGroup}) {
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
                padding: EdgeInsets.all(
                    (message.type == SendDataType.text) ? 10 : 4),
                margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
                decoration: BoxDecoration(
                    color: isMe
                        ? ColorResources().chatBubbleYourSideBG
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(isMe ? 10 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 10))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isGroup && !isMe)
                        Text(message.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: ColorResources().chatBubbleSenderName)),
                      (message.type == SendDataType.text)
                          ? textMessage(isMe: isMe, text: message.message)
                          : (message.type == SendDataType.image)
                              ? networkImages(link: message.message)
                              : BlocProvider<VideoThumbnailBloc>(
                                  create: (context) => VideoThumbnailBloc(),
                                  child: VideoThumbNail(link: message.message),
                                ),
                    ]),
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
  const NewMessageSend(
      {Key? key, required this.otherId, this.id, required this.isGroup})
      : super(key: key);
  final String otherId;
  final String? id;
  final bool isGroup;

  @override
  State<NewMessageSend> createState() => _NewMessageSendState();
}

class _NewMessageSendState extends State<NewMessageSend> {
  final TextEditingController _controller = TextEditingController();

  void sendMessage() {
    FocusScope.of(context).unfocus();
    BlocProvider.of<ChatBloc>(context).add(SendMessage(
        id: widget.id,
        context: context,
        message: _controller.text.trim(),
        otherUid: widget.otherId,
        type: SendDataType.text,
        isGroup: widget.isGroup));
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
          bottomSheet(context,
              otherUid: widget.otherId, isGroup: widget.isGroup, id: widget.id);
        },
        icon: Icon(IconResources().addOtherTypeOfMessage,
            color: ColorResources().textFieldIcon));
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
            width: 0, color: ColorResources().chatScreenTextFieldBorder),
        gapPadding: 10,
        borderRadius: BorderRadius.circular(25));
  }

  IconButton micFunction() {
    return IconButton(onPressed: () {
      SpeechApi.startRecording(onResult: (text, confidence) {
        if (confidence > 0) {
          return _controller.text += ' $text';
        }
      }, statusChange: (String text) {
        if (text == 'listening') {
          BlocProvider.of<SpeechToTextBloc>(context)
              .add(IsListening(isListening: true));
        } else if (text == 'notListening') {
          BlocProvider.of<SpeechToTextBloc>(context)
              .add(IsListening(isListening: false));
        }
      });
    }, icon: BlocBuilder<SpeechToTextBloc, SpeechToTextState>(
        builder: (context, state) {
      if (state is SpeechToTextStateListening) {
        return AvatarGlow(
          animate: state.isListening,
          endRadius: 200,
          glowColor: Theme.of(context).primaryColor,
          child: Icon(IconResources().micFromSpeechToText,
              color: ColorResources().textFieldIcon),
        );
      } else {
        return Icon(IconResources().micFromSpeechToTextNotWorking,
            color: ColorResources().textFieldIcon);
      }
    }));
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
        suffixIcon: micFunction(),
        filled: true,
        fillColor: ColorResources().sendMessageTextField,
        hintText: TextResources().sendMessageTextFieldHintText,
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
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
