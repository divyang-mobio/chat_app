import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../resources/resource.dart';
import 'network_image.dart';

ListView listView(
    {required List<UserModel> userData,
    required bool isLoading,
    bool isGroupScreen = false}) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: isLoading ? 20 : userData.length,
    itemBuilder: (context, index) => GestureDetector(
      onTap: () {
        if (!isGroupScreen) {
          Navigator.pushNamed(context, RoutesName().chat,
              arguments: userData[index]);
        }
      },
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isLoading
              ? ListTile(
                  leading: const CircleAvatar(radius: 30, child: SizedBox()),
                  title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(height: 10, color: Colors.grey)))
              : (isGroupScreen)
                  ? groupListTile(
                      context,
                      userData: userData[index],
                    )
                  : listTile(context, userData: userData[index])),
    ),
  );
}

ListTile groupListTile(context, {required UserModel userData}) {
  return ListTile(
    leading: circleAvatar(userData: userData, isGroupScreen: true),
    title: Text((userData.name == '') ? userData.phone : userData.name,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
    trailing: Checkbox(
      activeColor: Theme.of(context).primaryColor,
      value: true,
      onChanged: (bool? value) {},
    ),
  );
}

ListTile listTile(context, {required UserModel userData}) {
  return ListTile(
    leading: circleAvatar(userData: userData),
    title: Text((userData.name == '') ? userData.phone : userData.name,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
  );
}

CircleAvatar circleAvatar(
    {required UserModel userData, bool isGroupScreen = false}) {
  return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 30,
      child: Stack(
        children: [
          if (userData.profilePic == '')
            ClipOval(child: Image.asset(ImagePath().noImageImagePath))
          else
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(40),
                child: networkImages(link: userData.profilePic),
              ),
            ),
          if (!isGroupScreen)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CircleAvatar(
                      backgroundColor: userData.status
                          ? ColorResources().statusOnlineColor
                          : ColorResources().statusOfflineColor,
                      radius: 5),
                ),
              ),
            ),
        ],
      ));
}
