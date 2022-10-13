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

class BottomSheetList {
  List<BottomSheetModel> getBottomSheetData() {
    return [
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
  }
}

enum SendDataType {
  image,
  text,
  file,
  video,
}
