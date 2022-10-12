import 'package:image_picker/image_picker.dart';

import '../resources/resource.dart';

class BottomSheetModel {
  String title;
  SendDataType type;
  ImageSource imageSource;

  BottomSheetModel(
      {required this.title, required this.type, required this.imageSource});
}
