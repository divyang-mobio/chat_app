import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/chat_bloc/chat_bloc.dart';
import '../resources/resource.dart';
import 'alert_box.dart';

void uploadImage(context,
    {required ImageSource imageSource,
    required String otherUid,
    String? id,
    required bool isGroup,
    required SendDataType type,
    required bool isVideo}) async {
  final imagePicker = ImagePicker();
  XFile? image;
  await Permission.photos.request();
  var permissionStatus = await Permission.photos.status;
  if (permissionStatus.isGranted) {
    if (isVideo) {
      image = await imagePicker.pickVideo(source: imageSource);
    } else {
      image =
          await getImage(imageSource: imageSource, imagePicker: imagePicker);
    }
    if (image != null) {
      uploadToFireStore(context,
          file: image,
          otherUid: otherUid,
          type: type,
          isGroup: isGroup,
          id: id);
    }
  } else {
    await alertDialog(context, TextResources().permissionIsNotGiven);
  }
}

Future<XFile?> getImage(
    {required ImagePicker imagePicker,
    required ImageSource imageSource}) async {
  return await imagePicker.pickImage(source: imageSource, imageQuality: 30);
}

void uploadToFireStore(context,
    {required XFile file,
    required bool isGroup,
    String? id,
    required String otherUid,
    required SendDataType type}) async {
  final firebaseStorage = FirebaseStorage.instance;
  try {
    String url = await uploadImageToFirebase(
        firebaseStorage: firebaseStorage,
        path: TextResources().imageStoreInStoragePath,
        file: file);
    BlocProvider.of<ChatBloc>(context).add(SendMessage(
        id: id,
        context: context,
        message: url,
        otherUid: otherUid,
        type: type,
        isGroup: isGroup));
  } catch (e) {
    await alertDialog(context, TextResources().error);
  }
}

Future<String> uploadImageToFirebase(
    {required FirebaseStorage firebaseStorage,
    required XFile file,
    required String path}) async {
  var snapshot = await firebaseStorage
      .ref()
      .child('$path${file.name}')
      .putFile(File(file.path));
  var downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}
