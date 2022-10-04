import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controllers/login_Bloc/login_bloc.dart';
import 'resources/resource.dart';
import 'utils/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseAuth>(
            create: (context) => FirebaseAuth.instance),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(
                  auth: RepositoryProvider.of<FirebaseAuth>(context))),
        ],
        child: MaterialApp(
            title: 'chat app',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                textSelectionTheme:
                    const TextSelectionThemeData(selectionHandleColor: Colors.black),
                primarySwatch: Colors.grey,
                appBarTheme: const AppBarTheme(centerTitle: true)),
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: RoutesName().registrationRoute),
      ),
    );
  }
}
