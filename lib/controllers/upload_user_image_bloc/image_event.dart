part of 'image_bloc.dart';

abstract class ImageEvent {}

class UploadImage extends ImageEvent {}

class DeleteImage extends ImageEvent {
  String url;

  DeleteImage({required this.url});
}
