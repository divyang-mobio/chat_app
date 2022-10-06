import 'package:flutter/material.dart';

class PopupMenuItemModel {
  IconData iconData;
  String title;
  VoidCallback onPressed;

  PopupMenuItemModel(
      {required this.title, required this.iconData, required this.onPressed});
}
