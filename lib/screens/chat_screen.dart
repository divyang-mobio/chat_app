import '../controllers/chat_bloc/chat_bloc.dart';
import '../controllers/get_message_bloc/get_message_bloc.dart';
import '../models/group_model.dart';
import '../resources/resource.dart';
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
    BlocProvider.of<ChatBloc>(context)
        .add(GetId(otherUid: widget.userModel.uid));
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
              return showBody(isGroup: false);
            } else if (state is HaveID) {
              BlocProvider.of<GetMessageBloc>(context)
                  .add(MessageId(id: state.id, isGroup: false));
              return showBody(id: state.id, isGroup: false);
            } else {
              return Center(child: Text(TextResources().blocError));
            }
          },
        ));
  }
}

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key, required this.groupModel}) : super(key: key);

  final GroupModel groupModel;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {

  @override
  void initState() {
    super.initState();

    BlocProvider.of<GetMessageBloc>(context)
        .add(MessageId(id: widget.groupModel.id, isGroup: true));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 25,
            title: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesName().detailInfo,
                    arguments: widget.groupModel);
              },
              child: ListTile(
                  leading: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(20),
                      child: (widget.groupModel.image == '')
                          ? Image.asset(ImagePath().noImageImagePath)
                          : networkImages(link: widget.groupModel.image),
                    ),
                  ),
                  title: Text(widget.groupModel.groupName,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  textColor: ColorResources().appBarIconTextColor),
            )),
        body: showBody(id: widget.groupModel.id, isGroup: true));
  }
}

 showBody({String? id, required bool isGroup}) {
  return Column(
    children: [
      Expanded(
          child: Container(
        child: showMessage(id: id, isGroup: isGroup),
      )),
      NewMessageSend(
        otherId: '',
        id: id,
        isGroup: isGroup,
      )
    ],
  );
}
