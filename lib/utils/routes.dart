import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/update_profile_bloc/update_profile_bloc.dart';
import '../controllers/upload_user_image_bloc/image_bloc.dart';
import '../controllers/video_player_bloc/play_pause_bloc.dart';
import '../controllers/video_player_bloc/refresh_bloc.dart';
import '../screens/bottom_navigation_bar.dart';
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
      case '/mainScreen':
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case '/bottomScreen':
        return MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreen());
      case '/signIn':
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case '/videoPlay':
        final args = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PlayPauseBloc>(
                      create: (context) => PlayPauseBloc(),
                    ),
                    BlocProvider<RefreshBloc>(
                      create: (context) => RefreshBloc(),
                    ),
                  ],
                  child: VideoApp(
                    link: args,
                  ),
                ));
      case '/chat':
        final args = settings.arguments as UserModel;
        return MaterialPageRoute(
            builder: (context) => ChatScreen(userModel: args));
      default:
        return MaterialPageRoute(builder: (context) => const RedirectClass());
    }
  }
}
