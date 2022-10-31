import 'package:image_picker/image_picker.dart';

import '../resources/resource.dart';

class BottomSheetModel {
  String title;
  SendDataType type;
  ImageSource imageSource;
  bool isVideo;

  BottomSheetModel(
      {required this.title,
      required this.type,
      required this.imageSource,
      required this.isVideo});
}

class GroupBottomSheet {
  String title;
  NavigatorType type;

  GroupBottomSheet({required this.title, required this.type});
}
