

import 'package:flutter/material.dart';

import '../resources/resource.dart';

GestureDetector showProfilePic(
    {required GestureTapCallback onTap, required Widget child}) {
  return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
          backgroundColor: ColorResources().registrationImageBg,
          radius: 60,
          child: child));
}