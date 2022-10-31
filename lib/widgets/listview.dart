import 'package:chat_app/controllers/group_bloc/add_data_group_bloc.dart';
import 'package:chat_app/widgets/common_widgets_of_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import '../resources/resource.dart';
import 'bottom_sheet.dart';
import 'network_image.dart';

ListView listView(
    {required List<UserModel> userData,
    required bool isLoading,
    int length = 20,
    String groupId = '',
    List<String> adminList = const [],
    bool isAdmin = false}) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: isLoading ? length : userData.length,
    itemBuilder: (context, index) => GestureDetector(
      onTap: () {
        if (isAdmin) {
          groupBottomSheet(context,
              userModel: userData[index], groupId: groupId);
        } else {
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
              : listTile(context,
                  userData: userData[index],
                  isAdmin: adminList.contains(userData[index].uid))),
    ),
  );
}

groupListViewListView(context,
    {required List<UserModel> userData, bool isGroupScreen = false}) {
  return BlocBuilder<AddDataGroupBloc, AddDataGroupState>(
    builder: (context, state) {
      if (state is AddDataGroupInitial) {
        return shimmerLoading();
      } else if (state is AddDataGroupLoading) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: userData.length,
          itemBuilder: (context, index) {
            final value = state.data.contains(userData[index]);
            return Padding(
                padding: const EdgeInsets.all(15.0),
                child: groupListTile(context,
                    userData: userData[index], values: value));
          },
        );
      } else {
        return Text(TextResources().error);
      }
    },
  );
}

CheckboxListTile groupListTile(context,
    {required UserModel userData, bool values = false}) {
  return CheckboxListTile(
    title: Row(children: [
      circleAvatar(userData: userData, isGroupScreen: true),
      const SizedBox(width: 15),
      Flexible(
        child: Text((userData.name == '') ? userData.phone : userData.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      ),
    ]),
    value: values,
    onChanged: (value) {
      if (value == true) {
        BlocProvider.of<AddDataGroupBloc>(context)
            .add(AddMember(userModel: [userData]));
      } else if (value == false) {
        BlocProvider.of<AddDataGroupBloc>(context)
            .add(RemoveMember(userModel: userData));
      }
    },
  );
}

ListTile listTile(context,
    {required UserModel userData, bool isAdmin = false}) {
  return ListTile(
    leading: circleAvatar(userData: userData),
    title: Text((userData.name == '') ? userData.phone : userData.name,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
    trailing: isAdmin ? const Text('~Admin') : null,
  );
}

GestureDetector groupNameListTile(context, {required GroupModel groupModel}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, RoutesName().groupChat,
          arguments: groupModel);
    },
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 30,
        child: (groupModel.image == '')
            ? ClipOval(child: Image.asset(ImagePath().noImageImagePath))
            : ClipOval(
                child: SizedBox.fromSize(
                    size: const Size.fromRadius(40),
                    child: networkImages(link: groupModel.image)),
              ),
      ),
      title: Text(groupModel.groupName,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
    ),
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
