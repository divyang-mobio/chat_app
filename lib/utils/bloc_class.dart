import 'package:chat_app/controllers/chat_bloc/chat_bloc.dart';
import 'package:chat_app/controllers/get_status_bloc/get_status_bloc.dart';
import '../controllers/bottom_nav_bloc/bottom_navigation_bloc.dart';
import '../controllers/chat_list/chat_list_bloc.dart';
import '../controllers/chat_list/get_user_data_bloc.dart';
import '../controllers/group_bloc/create_group_bloc.dart';
import '../controllers/group_bloc/get_group_bloc.dart';
import '../controllers/like_message_bloc/like_message_bloc.dart';
import '../controllers/login_Bloc/set_otp_field_bloc.dart';
import '../controllers/show_Status_bloc/show_status_bloc.dart';
import '../controllers/speech_to_text_bloc/speech_to_text_bloc.dart';
import '../controllers/upload_status_bloc/upload_status_bloc.dart';
import '../controllers/user_bloc/new_contact_bloc.dart';
import '../controllers/video_player_bloc/visible_container_bloc.dart';
import 'firebase_auth.dart';
import '../controllers/login_Bloc/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'material_class.dart';

class RepositoryClass extends StatelessWidget {
  const RepositoryClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<FirebaseAuth>(
          create: (context) => FirebaseAuth.instance)
    ], child: const BlocClass());
  }
}

class BlocClass extends StatelessWidget {
  const BlocClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            firebaseAuth: FirebaseAuthService(
                firebaseAuth: RepositoryProvider.of<FirebaseAuth>(context))),
      ),
      BlocProvider<NewContactBloc>(
          create: (context) => NewContactBloc()..add(GetNewContactData())),
      BlocProvider<CreateGroupBloc>(create: (context) => CreateGroupBloc()),
      BlocProvider<ShowStatusBloc>(create: (context) => ShowStatusBloc()),
      BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
      BlocProvider<UploadStatusBloc>(create: (context) => UploadStatusBloc()),
      BlocProvider<GetStatusBloc>(
          create: (context) => GetStatusBloc()..add(GetStatusData())),
      BlocProvider<SetOtpFieldBloc>(create: (context) => SetOtpFieldBloc()),
      BlocProvider<ChatListBloc>(
          create: (context) => ChatListBloc()..add(GetChatList())),
      BlocProvider<GetUserDataBloc>(create: (context) => GetUserDataBloc()),
      BlocProvider<GetGroupBloc>(
          create: (context) => GetGroupBloc()..add(GetGroupsId())),
      BlocProvider<LikeMessageBloc>(
          create: (context) => LikeMessageBloc()),
      BlocProvider<SpeechToTextBloc>(
          create: (context) =>
              SpeechToTextBloc()..add(IsListening(isListening: false))),
      BlocProvider<BottomNavigationBloc>(
          create: (context) =>
              BottomNavigationBloc()..add(OnChangeBar(index: 0))),
      BlocProvider<VisibleContainerBloc>(
          create: (context) =>
              VisibleContainerBloc()..add(ShowContainer(isVis: true)))
    ], child: const MaterialClass());
  }
}
