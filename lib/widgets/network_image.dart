import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/video_thumbnail_bloc/video_thumbnail_bloc.dart';
import '../resources/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

networkImages({required String link, BoxFit? fit}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      imageUrl: link,
      fit: fit ?? BoxFit.fill,
      placeholder: (context, url) =>
          const SizedBox(child: CircularProgressIndicator()),
    ),
  );
}

class VideoThumbNail extends StatefulWidget {
  const VideoThumbNail({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  State<VideoThumbNail> createState() => _VideoThumbNailState();
}

class _VideoThumbNailState extends State<VideoThumbNail> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VideoThumbnailBloc>(context)
        .add(GetThumbNail(link: widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoThumbnailBloc, VideoThumbnailState>(
        builder: (context, state) {
      if (state is VideoThumbnailInitial) {
        return const CircularProgressIndicator.adaptive();
      } else if (state is VideoThumbnailLoaded) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, RoutesName().videoPlay,
              arguments: widget.link),
          child: Stack(alignment: Alignment.center, children: [
            Image.file(state.file),
            CircleAvatar(
              backgroundColor: ColorResources().videoPlayContainer,
              child: Icon(IconResources().videoPlay,
                  color: ColorResources().videoPlayIconText),
            )
          ]),
        );
      } else {
        return Text(TextResources().error);
      }
    });
  }
}
