part of 'image_bloc.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  String url;

  ImageLoaded({required this.url});
}

class ImageError extends ImageState {}
