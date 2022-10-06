import 'package:flutter/material.dart';
import '../resources/resource.dart';
import 'routes.dart';
import 'theme.dart';

class MaterialClass extends StatelessWidget {
  const MaterialClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'chat app',
        theme: MyTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: RoutesName().redirectRoute);
  }
}
