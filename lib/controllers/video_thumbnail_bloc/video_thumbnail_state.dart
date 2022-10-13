part of 'video_thumbnail_bloc.dart';

abstract class VideoThumbnailState {}

class VideoThumbnailInitial extends VideoThumbnailState {}

class VideoThumbnailLoaded extends VideoThumbnailState {
  File file;

  VideoThumbnailLoaded({required this.file});
}

class VideoThumbnailError extends VideoThumbnailState {}
