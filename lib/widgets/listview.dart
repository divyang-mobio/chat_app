import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../resources/resource.dart';
import 'network_image.dart';

ListView listView(
    {required List<UserModel> userData, required bool isLoading}) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: isLoading ? 20 : userData.length,
    itemBuilder: (context, index) => GestureDetector(
      onTap: () => Navigator.pushNamed(context, RoutesName().chat,
          arguments: userData[index]),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                child: isLoading
                    ? null
                    : Stack(
                        children: [
                          if (userData[index].profilePic == '')
                            ClipOval(
                                child:
                                    Image.asset(ImagePath().noImageImagePath))
                          else
                            ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(40),
                                child: networkImages(
                                    link: userData[index].profilePic),
                              ),
                            ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: isLoading
                                  ? const SizedBox()
                                  : CircleAvatar(
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
                : Text(
                    (userData[index].name == '')
                        ? userData[index].phone
                        : userData[index].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 19))),
      ),
    ),
  );
}
