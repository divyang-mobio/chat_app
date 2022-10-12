import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../resources/resource.dart';

ListView listView(
    {required List<UserModel> userData, required bool isLoading}) {
  return ListView.builder(
    itemCount: isLoading ? 20 : userData.length,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, RoutesName().chat,
            arguments: userData[index]),
        child: Column(
          children: [
            ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                    child: Stack(
                      children: [
                        ClipOval(
                            child: Image.asset(ImagePath().noImageImagePath)),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: isLoading  ? const SizedBox() :CircleAvatar(
                                backgroundColor: userData[index].status
                                    ? ColorResources().statusOnlineColor
                                    : ColorResources().statusOfflineColor,
                                radius: 7),
                          ),
                        ),
                      ],
                    )),
                title: isLoading
                    ? Container()
                    : Text(userData[index].name)),
            Divider(color: ColorResources().dividerColor)
          ],
        ),
      ),
    ),
  );
}
