part of 'video_thumbnail_bloc.dart';

abstract class VideoThumbnailEvent {}

class GetThumbNail extends VideoThumbnailEvent {
  String link;

  GetThumbNail({required this.link});
}

