import 'package:avatar_glow/avatar_glow.dart';
import 'text_to_speech_widget.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import '../controllers/reply_bloc/reply_bloc.dart';
import '../controllers/speech_to_text_bloc/speech_to_text_bloc.dart';
import '../controllers/video_thumbnail_bloc/video_thumbnail_bloc.dart';
import 'bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/chat_bloc/chat_bloc.dart';
import '../models/message_model.dart';
import '../resources/resource.dart';
import '../utils/firestore_service.dart';
import 'package:swipe_to/swipe_to.dart';
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
                              id: id,
                              isMe: true,
                              isGroup: isGroup)
                          : showMessageWidget(context,
                              message: message[index],
                              id: id,
                              isMe: false,
                              isGroup: isGroup);
                    },
                  );
          },
        );
}

FocusedMenuHolder showPopUpForDelete(context,
    {required MessageModel message,
    required String id,
    required bool isMe,
    required bool isGroup}) {
  return FocusedMenuHolder(
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
            trailingIcon: Icon(IconResources().deleteMessageButton),
            title: Text(TextResources().deleteMessageButton),
            onPressed: () {
              DatabaseService()
                  .deleteMessage(isGroup: isGroup, otherId: message.id, id: id);
            })
      ],
      child:
          chatBubble(context, message: message, isMe: isMe, isGroup: isGroup));
}

SwipeTo showMessageWidget(context,
    {required MessageModel message,
    required bool isMe,
    required String id,
    required bool isGroup}) {
  return SwipeTo(
    onRightSwipe: () {
      BlocProvider.of<ReplyBloc>(context).add(ReplyMessage(
          messageModel: MessageModel(
              message: message.message,
              name: message.name,
              uid: message.uid,
              id: message.id,
              data: message.data,
              type: message.type)));
    },
    child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe) const Flexible(flex: 1, child: SizedBox()),
          Flexible(
              flex: 2,
              child: isMe
                  ? showPopUpForDelete(context,
                      message: message, isMe: isMe, isGroup: isGroup, id: id)
                  : chatBubble(context,
                      message: message, isMe: isMe, isGroup: isGroup)),
          if (!isMe) const Flexible(flex: 1, child: SizedBox()),
        ]),
  );
}

chatBubble(context,
    {required MessageModel message,
    required bool isMe,
    required bool isGroup}) {
  return
      // SwipeTo(
      //   onRightSwipe: () {
      //     print(message.message);
      //     BlocProvider.of<ReplyBloc>(context).add(ReplyMessage(
      //         messageModel: message));
      //   },
      // child:
      Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
        Container(
          padding: EdgeInsets.all((message.type == SendDataType.text) ? 10 : 4),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (isGroup && !isMe)
              Text(message.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: ColorResources().chatBubbleSenderName)),
            if (message.reply != null)
              Column(children: [
                replyCard(context,
                    messageModel: message.reply as MessageModel,
                    isChatBubble: true),
                const SizedBox(height: 10),
              ]),
            (message.type == SendDataType.text)
                ? textMessage(isMe: isMe, text: message.message)
                : (message.type == SendDataType.image)
                    ? networkImages(link: message.message)
                    : BlocProvider<VideoThumbnailBloc>(
                        create: (context) => VideoThumbnailBloc(),
                        child: VideoThumbNail(link: message.message))
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(message.data,
              style: TextStyle(color: ColorResources().chatScreenDate)),
        ),
      ]);
  // );
}

Text textMessage({required String text, required bool isMe}) {
  return Text(text,
      style: TextStyle(
          color: isMe
              ? ColorResources().chatBubbleYourSideText
              : ColorResources().chatBubbleOtherSideText));
}

Container replyCard(context,
    {required MessageModel messageModel, required bool isChatBubble}) {
  return Container(
    decoration: BoxDecoration(
        color: ColorResources().sendMessageTextField,
        borderRadius: BorderRadius.only(
            topRight: isChatBubble
                ? const Radius.circular(10)
                : const Radius.circular(25),
            topLeft: isChatBubble
                ? const Radius.circular(10)
                : const Radius.circular(25),
            bottomRight: isChatBubble ? const Radius.circular(10) : Radius.zero,
            bottomLeft:
                isChatBubble ? const Radius.circular(10) : Radius.zero)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(
            left: isChatBubble ? 8 : 18,
            right: 8,
            top: 8,
            bottom: isChatBubble ? 8 : 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(messageModel.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          (messageModel.type == SendDataType.text)
              ? Text(messageModel.message, overflow: TextOverflow.ellipsis)
              : (messageModel.type == SendDataType.image)
                  ? SizedBox(
                      height: 100,
                      width: 100,
                      child: networkImages(link: messageModel.message))
                  : BlocProvider<VideoThumbnailBloc>(
                      create: (context) => VideoThumbnailBloc(),
                      child: SizedBox(
                          height: 100,
                          width: 100,
                          child: VideoThumbNail(link: messageModel.message)))
        ]),
      )),
      if (!isChatBubble)
        IconButton(
            onPressed: () {
              BlocProvider.of<ReplyBloc>(context).add(CancelReply());
            },
            icon: Icon(IconResources().removeReply))
    ]),
  );
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

  void sendMessage(MessageModel? messageModel) {
    FocusScope.of(context).unfocus();
    BlocProvider.of<ChatBloc>(context).add(SendMessage(
        id: widget.id,
        context: context,
        messageModel: messageModel,
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

  OutlineInputBorder outlineInputBorder(bool isReply) {
    return OutlineInputBorder(
        borderSide: BorderSide.none,
        gapPadding: 10,
        borderRadius: BorderRadius.only(
            topRight: isReply ? Radius.zero : const Radius.circular(25),
            topLeft: isReply ? Radius.zero : const Radius.circular(25),
            bottomRight: const Radius.circular(25),
            bottomLeft: const Radius.circular(25)));
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

  TextField textField({required bool isReplay}) {
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
        enabledBorder: outlineInputBorder(isReplay),
        focusedBorder: outlineInputBorder(isReplay),
      ),
    );
  }

  GestureDetector sendButton(
      {required bool isReply, MessageModel? messageModel}) {
    return GestureDetector(
      onTap: () {
        if (isReply && !(_controller.text.trim() == '')) {
          BlocProvider.of<ReplyBloc>(context).add(CancelReply());
        }
        _controller.text.trim() == '' ? null : sendMessage(messageModel);
      },
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 25,
        child: Icon(IconResources().sendMessage,
            color: ColorResources().sendMessageIcon),
      ),
    );
  }

  Row textFieldBody(bool isReply, MessageModel? messageModel) {
    return Row(children: [
      Expanded(
          child: Column(
        children: [
          if (isReply)
            replyCard(context,
                messageModel: messageModel as MessageModel,
                isChatBubble: false),
          textField(isReplay: isReply),
        ],
      )),
      const SizedBox(width: 10),
      sendButton(isReply: isReply, messageModel: messageModel)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<ReplyBloc, ReplyState>(
        builder: (context, state) {
          if (state is ReplyInitial) {
            return textFieldBody(false, null);
          } else if (state is ReplyMessageData) {
            return textFieldBody(true, state.messageModel);
          } else {
            return textFieldBody(false, null);
          }
        },
      ),
    );
  }
}
