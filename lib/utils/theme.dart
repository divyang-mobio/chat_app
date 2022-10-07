import 'package:flutter/material.dart';
import '../resources/resource.dart';

class MyTheme {
  static final lightTheme = ThemeData(
      primaryColor: ColorResources().primaryColor,
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: ColorResources().selectionHandleColor),
      appBarTheme: AppBarTheme(
          backgroundColor: ColorResources().appBar,
          foregroundColor: ColorResources().appBarIconTextColor));
}
