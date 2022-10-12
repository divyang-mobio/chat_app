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
          imageSource: ImageSource.camera),
      BottomSheetModel(
          title: 'Upload Video',
          type: SendDataType.file,
          imageSource: ImageSource.gallery),
      BottomSheetModel(
          title: 'Upload Image',
          type: SendDataType.image,
          imageSource: ImageSource.gallery),
    ];
  }
}

enum SendDataType {
  image,
  text,
  file,
  video,
}
