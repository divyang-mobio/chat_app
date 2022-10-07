import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../resources/resource.dart';

ListView listView(
    {required List<UserModel> userData, required bool isLoading}) {
  return ListView.builder(
    itemCount: isLoading ? 20 : userData.length,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
          leading: CircleAvatar(
              radius: 40,
              child:
                  ClipOval(child: Image.asset(ImagePath().noImageImagePath))),
          title: isLoading ? Container() : Text(userData[index].name)),
    ),
  );
}
