import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/login_Bloc/login_bloc.dart';
import 'material_class.dart';

class RepositoryClass extends StatelessWidget {
  const RepositoryClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<FirebaseAuth>(
          create: (context) => FirebaseAuth.instance),
    ], child: const BlocClass());
  }
}

class BlocClass extends StatelessWidget {
  const BlocClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginBloc>(
          create: (context) =>
              LoginBloc(auth: RepositoryProvider.of<FirebaseAuth>(context))),
    ], child: const MaterialClass());
  }
}
