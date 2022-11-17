import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app/controllers/edit_text_bloc/edit_text_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import '../controllers/get_message_bloc/get_message_bloc.dart';
import '../controllers/like_message_bloc/like_message_bloc.dart';
import '../utils/chat_menu.dart';
import 'text_to_speech_widget.dart';
import 'package:flutter/material.dart';
import '../controllers/reply_bloc/reply_bloc.dart';
import '../controllers/speech_to_text_bloc/speech_to_text_bloc.dart';
import '../controllers/video_thumbnail_bloc/video_thumbnail_bloc.dart';
import 'bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/chat_bloc/chat_bloc.dart';
import '../models/message_model.dart';
import '../resources/resource.dart';
import '../utils/firestore_service.dart';
import 'network_image.dart';

showMessage({String? id, required bool isGroup}) {
  return (id == null)
      ? Container()
      : BlocBuilder<GetMessageBloc, GetMessageState>(
          builder: (context, state) {
            if (state is GetMessageLoaded) {
              return StreamBuilder<List<MessageModel>>(
                stream: state.data,
                builder: (context, snapshot) {
                  final message = snapshot.data;
                  return message == null
                      ? Container()
                      : GroupedListView<dynamic, String>(
                          reverse: true,
                          elements: message,
                          groupBy: (element) {
                            return element.data
                                .substring(0, element.data.indexOf('T'));
                          },
                          itemComparator: (item1, item2) =>
                              item1.data.compareTo(item2.data),
                          order: GroupedListOrder.DESC,
                          useStickyGroupSeparators: false,
                          groupSeparatorBuilder: (String value) =>
                              messageTimeContainer(value: value),
                          itemBuilder: (c, element) {
                            return (element.uid ==
                                    (RepositoryProvider.of<FirebaseAuth>(
                                                context)
                                            .currentUser
                                            ?.uid)
                                        .toString())
                                ? showMessageWidget(context,
                                    messageModel: element,
                                    id: id,
                                    isMe: true,
                                    isGroup: isGroup)
                                : showMessageWidget(context,
                                    messageModel: element,
                                    id: id,
                                    isMe: false,
                                    isGroup: isGroup);
                          },
                        );
                },
              );
            } else {
              return Container();
            }
          },
        );
}

SizedBox messageTimeContainer({required String value}) {
  return SizedBox(
    height: 40,
    child: Align(
      child: Container(
        width: 120,
        decoration: BoxDecoration(
            color: ColorResources().messageHeaderBubbleBG,
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              (value == "${DateTime.now().month}/${DateTime.now().day}")
                  ? TextResources().todayMessageHeader
                  : value,
              textAlign: TextAlign.center),
        ),
      ),
    ),
  );
}

DeepMenus showPopUpForMenu(context,
    {required MessageModel message,
    required String id,
    required bool isMe,
    required bool isGroup}) {
  return DeepMenus(
      headMenu: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: ColorResources().messageReactionBubbleBG),
        height: 50,
        child: Material(
          color: Colors.transparent,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            scrollDirection: Axis.horizontal,
            children: reactionList
                .map(
                  (e) => TextButton(
                      onPressed: () {
                        BlocProvider.of<LikeMessageBloc>(context).add(
                            LikeMessageData(
                                messageModel: message,
                                type: e.type,
                                id: id,
                                isGroup: isGroup));
                        Navigator.pop(context);
                      },
                      child: Text(
                        e.reaction,
                        style: const TextStyle(fontSize: 30),
                      )),
                )
                .toList(),
          ),
        ),
      ),
      bodyMenu: DeepMenuList(items: [
        if (isMe)
          DeepMenuItem(
              icon: Icon(IconResources().deleteMessageButton),
              label: Text(TextResources().deleteMessageButton),
              onTap: () {
                DatabaseService().deleteMessage(
                    isGroup: isGroup, otherId: message.id, id: id);
              }),
        DeepMenuItem(
            icon: Icon(IconResources().replyMessageButton),
            label: Text(TextResources().replyMessageButton),
            onTap: () {
              BlocProvider.of<ReplyBloc>(context).add(ReplyMessage(
                  messageModel: MessageModel(
                      message: message.message,
                      name: message.name,
                      uid: message.uid,
                      id: message.id,
                      data: message.data,
                      type: message.type)));
            }),
        if (message.type == SendDataType.text && isMe)
          DeepMenuItem(
              icon: Icon(IconResources().editMessageButton),
              label: Text(TextResources().editMessageButton),
              onTap: () {
                BlocProvider.of<EditTextBloc>(context)
                    .add(EditText(messageModel: message, id: id));
              })
      ]),
      child: chatBubble(context,
          message: message, isMe: isMe, isGroup: isGroup, id: id));
}

showMessageWidget(context,
    {required MessageModel messageModel,
    required bool isMe,
    required String id,
    required bool isGroup}) {
  return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMe) const Flexible(flex: 1, child: SizedBox()),
        Flexible(
            flex: 2,
            child: isMe
                ? showPopUpForMenu(context,
                    message: messageModel, isMe: isMe, isGroup: isGroup, id: id)
                : showPopUpForMenu(context,
                    message: messageModel,
                    isMe: isMe,
                    isGroup: isGroup,
                    id: id)),
        if (!isMe) const Flexible(flex: 1, child: SizedBox()),
      ]);
}

chatBubble(context,
    {required MessageModel message,
    required bool isMe,
    required String id,
    required bool isGroup}) {
  return Stack(
    alignment: isMe
        ? AlignmentDirectional.bottomEnd
        : AlignmentDirectional.bottomStart,
    children: [
      Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.all((message.type == SendDataType.text) ? 10 : 4),
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
              child: Wrap(
                  alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
                  children: [
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
                                child: VideoThumbNail(link: message.message)),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(message.data.split('T').last,
                          style: TextStyle(
                              color: ColorResources().chatScreenDate)),
                    ),
                  ]),
            ),
            if (message.like != null && message.like!.isNotEmpty)
              const SizedBox(height: 15)
          ]),
      if (message.like != null && message.like!.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<LikeMessageBloc>(context).add(
                  DeleteLikeMessageData(
                      messageModel: message, id: id, isGroup: isGroup));
            },
            child: reactionShowText(context,
                isGroup: isGroup, type: message.like as List<LikeModel>),
          ),
        ),
    ],
  );
}

reactionShowText(context,
    {required bool isGroup, required List<LikeModel> type}) {
  int index = type.indexWhere(
      (element) =>
          element.id ==
          '${RepositoryProvider.of<FirebaseAuth>(context).currentUser?.uid}',
      0);
  return Text(
    reactionDisplay((index != -1) ? type[index].type : type[0].type),
    style: const TextStyle(fontSize: 20),
  );
}

reactionDisplay(ReactionType type) {
  switch (type) {
    case ReactionType.thumbUp:
      return TextResources().thumbUpReaction;
    case ReactionType.pray:
      return TextResources().prayReaction;
    case ReactionType.sad:
      return TextResources().sadReaction;
    case ReactionType.wow:
      return TextResources().wowReaction;
    case ReactionType.love:
      return TextResources().loveReaction;
    case ReactionType.happy:
      return TextResources().happyReaction;
  }
}

Text textMessage({required String text, required bool isMe}) {
  return Text(text,
      style: TextStyle(
          color: isMe
              ? ColorResources().chatBubbleYourSideText
              : ColorResources().chatBubbleOtherSideText));
}

replyCard(context,
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
      Padding(
        padding: EdgeInsets.only(
            left: isChatBubble ? 8 : 18,
            right: 8,
            top: 8,
            bottom: isChatBubble ? 8 : 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(messageModel.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip),
          (messageModel.type == SendDataType.text)
              ? Text(messageModel.message, overflow: TextOverflow.clip)
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
      ),
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

  GestureDetector editTextButton(
      {required IconData iconData,
      required GestureTapCallback onTap,
      required Color bgColor}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: bgColor,
        radius: 25,
        child: Icon(iconData, color: ColorResources().sendMessageIcon),
      ),
    );
  }

  BlocBuilder textFieldBody(bool isReply, MessageModel? messageModel) {
    return BlocBuilder<EditTextBloc, EditTextState>(builder: (context, state) {
      if (state is EnterText) {
        _controller.text = state.messageModel.message;
        return Row(children: [
          editTextButton(
              iconData: IconResources().cancelEditTextField,
              onTap: () {
                BlocProvider.of<EditTextBloc>(context).add(CancelEditText());
              },
              bgColor: ColorResources().cancelEditTextFieldBG),
          const SizedBox(width: 10),
          Expanded(child: textField(isReplay: isReply)),
          const SizedBox(width: 10),
          editTextButton(
              iconData: IconResources().sendMessage,
              onTap: () {
                BlocProvider.of<EditTextBloc>(context).add(SendEditText(
                    id: state.id,
                    message: _controller.text,
                    isGroup: widget.isGroup,
                    otherId: state.messageModel.id));
              },
              bgColor: Theme.of(context).primaryColor)
        ]);
      } else {
        _controller.text = '';
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
    });
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
