import 'package:chat_app/controllers/group_bloc/user_detail_bloc.dart';
import 'package:chat_app/models/group_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/create_group_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/group_bloc/add_data_group_bloc.dart';
import '../controllers/group_bloc/send_group_data_bloc.dart';
import '../controllers/update_profile_bloc/update_profile_bloc.dart';
import '../controllers/upload_user_image_bloc/image_bloc.dart';
import '../controllers/video_player_bloc/play_pause_bloc.dart';
import '../controllers/video_player_bloc/refresh_bloc.dart';
import '../screens/bottom_navigation_bar_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/select_member_screen.dart';
import '../screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../screens/signIn_screen.dart';
import '../widgets/video_play.dart';
import 'redirect_class.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const RedirectClass());
      case '/signUp':
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<UpdateProfileBloc>(
                        create: (context) => UpdateProfileBloc()),
                    BlocProvider<ImageBloc>(create: (context) => ImageBloc()),
                  ],
                  child: const RegistrationScreen(),
                ));
      case '/groupRegistration':
        final args = settings.arguments as List<UserModel>;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SendGroupDataBloc>(
                        create: (context) => SendGroupDataBloc()),
                    BlocProvider<ImageBloc>(create: (context) => ImageBloc()),
                  ],
                  child: RegistrationGroupScreen(member: args),
                ));
      case '/mainScreen':
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case '/bottomScreen':
        return MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreen());
      case '/GroupContactScreen':
        return MaterialPageRoute(
            builder: (context) => BlocProvider<AddDataGroupBloc>(
                  create: (context) =>
                      AddDataGroupBloc()..add(AddMember(userModel: [])),
                  child: const CreateGroupScreen(),
                ));
      case '/signIn':
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case '/videoPlay':
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider<PlayPauseBloc>(
                      create: (context) => PlayPauseBloc()),
                  BlocProvider<RefreshBloc>(create: (context) => RefreshBloc()),
                ], child: VideoApp(link: args)));
      case '/chat':
        final args = settings.arguments as UserModel;
        return MaterialPageRoute(
            builder: (context) => ChatScreen(userModel: args));
      case '/chatGroup':
        final args = settings.arguments as GroupModel;
        return MaterialPageRoute(
            builder: (context) => GroupChatScreen(groupModel: args));
      case '/groupInfo':
        final args = settings.arguments as GroupModel;
        return MaterialPageRoute(
            builder: (context) => BlocProvider<UserDetailBloc>(
                create: (context) => UserDetailBloc(groupModel: args)
                  ..add(UserIds(ids: args.persons)),
                child: DetailScreen(groupModel: args)));
      default:
        return MaterialPageRoute(builder: (context) => const RedirectClass());
    }
  }
}
