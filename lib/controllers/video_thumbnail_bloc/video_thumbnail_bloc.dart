import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'video_thumbnail_event.dart';

part 'video_thumbnail_state.dart';

class VideoThumbnailBloc
    extends Bloc<VideoThumbnailEvent, VideoThumbnailState> {
  VideoThumbnailBloc() : super(VideoThumbnailInitial()) {
    on<GetThumbNail>((event, emit) async {
      try {
        String? image = await VideoThumbnail.thumbnailFile(
          video: event.link,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 350,
          quality: 30,
        );
        if (image != null) {
          emit(VideoThumbnailLoaded(file: File(image)));
        }
      } catch (e) {
        emit(VideoThumbnailError());
      }
    });
  }
}
