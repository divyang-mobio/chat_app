part of 'resource.dart';

class ListResources {
  List<PopupMenuItemModel> getPopUpData(BuildContext context) {
    List<PopupMenuItemModel> popupMenuList = [
      PopupMenuItemModel(
          title: TextResources().logout,
          iconData: IconResources().logout,
          onPressed: () => BlocProvider.of<LoginBloc>(context).add(LogOut()))
    ];
    return popupMenuList;
  }
}

List<BottomSheetModel> getBottomSheetData = [
  BottomSheetModel(
      title: 'Open Camera',
      type: SendDataType.image,
      imageSource: ImageSource.camera,
      isVideo: false),
  BottomSheetModel(
      title: 'Upload Video',
      type: SendDataType.video,
      imageSource: ImageSource.gallery,
      isVideo: true),
  BottomSheetModel(
      title: 'Open Video',
      type: SendDataType.video,
      imageSource: ImageSource.camera,
      isVideo: true),
  BottomSheetModel(
      title: 'Upload Image',
      type: SendDataType.image,
      imageSource: ImageSource.gallery,
      isVideo: false),
];

List<GroupBottomSheet> getGroupBottomSheet = [
  GroupBottomSheet(title: 'chat', type: NavigatorType.info),
  GroupBottomSheet(title: 'make admin', type: NavigatorType.admin),
  GroupBottomSheet(title: 'remove from group', type: NavigatorType.remove)
];

List<StatusBottomSheetModel> statusBottomSheetData = [
  StatusBottomSheetModel(
      title: 'Open Camera',
      type: SendDataType.image,
      imageSource: ImageSource.camera),
  StatusBottomSheetModel(
      title: 'Upload Video',
      type: SendDataType.video,
      imageSource: ImageSource.gallery),
  StatusBottomSheetModel(
      title: 'Open Video',
      type: SendDataType.video,
      imageSource: ImageSource.camera),
  StatusBottomSheetModel(
      title: 'Upload Image',
      type: SendDataType.image,
      imageSource: ImageSource.gallery),
];

List<BottomNavModel> bottomNav = [
  BottomNavModel(
      label: TextResources().bottomNavMessage,
      iconData: IconResources().bottomNavMessage),
  BottomNavModel(label: 'Groups', iconData: Icons.groups),
  BottomNavModel(label: 'Status', iconData: Icons.data_saver_off),
  BottomNavModel(
      label: TextResources().bottomNavContact,
      iconData: IconResources().bottomNavContact)
];

List<AppBarModel> appbarModel = [
  AppBarModel(title: AppTitle().mainScreen, actions: [
    IconButton(onPressed: () {}, icon: Icon(IconResources().search)),
    popupMenuButton()
  ]),
  AppBarModel(title: AppTitle().groupScreen, actions: [
    IconButton(onPressed: () {}, icon: Icon(IconResources().search))
  ]),
  AppBarModel(title: AppTitle().statusScreen, actions: [
    IconButton(onPressed: () {}, icon: Icon(IconResources().search))
  ]),
  AppBarModel(title: AppTitle().newContactScreen, actions: [
    IconButton(onPressed: () {}, icon: Icon(IconResources().search))
  ])
];

enum SendDataType {
  image,
  text,
  file,
  video,
}

enum NavigatorType { info, admin, remove }
