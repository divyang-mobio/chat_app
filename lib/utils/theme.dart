import 'package:flutter/material.dart';
import '../resources/resource.dart';

class MyTheme {
  static final lightTheme = ThemeData(
      primaryColor: ColorResources().primaryColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showUnselectedLabels: true,
          unselectedItemColor: ColorResources().bottomNavBarUnSelectedItem,
          unselectedLabelStyle:
              TextStyle(color: ColorResources().bottomNavBarUnSelectedItem),
          elevation: 0),
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: ColorResources().selectionHandleColor),
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: ColorResources().appBar,
          iconTheme: IconThemeData(color: ColorResources().appBarIconTextColor),
          foregroundColor: ColorResources().appBarIconTextColor));
}
