import 'package:chat_app/controllers/chat_bloc/chat_bloc.dart';
import 'package:chat_app/controllers/upload_user_image_bloc/image_bloc.dart';

import '../controllers/show_Status_bloc/show_status_bloc.dart';
import '../controllers/update_profile_bloc/update_profile_bloc.dart';
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
      BlocProvider<NewContactBloc>(create: (context) => NewContactBloc()),
      BlocProvider<ShowStatusBloc>(create: (context) => ShowStatusBloc()),
      BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
      BlocProvider<VisibleContainerBloc>(
          create: (context) =>
              VisibleContainerBloc()..add(ShowContainer(isVis: true)))
    ], child: const MaterialClass());
  }
}
