import 'routes.dart';
import 'package:flutter/material.dart';

import '../resources/resource.dart';

class MaterialClass extends StatelessWidget {
  const MaterialClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'chat app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
                selectionHandleColor: Colors.black),
            primarySwatch: Colors.grey,
            appBarTheme: const AppBarTheme(centerTitle: true)),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: RoutesName().redirectRoute);
  }
}
