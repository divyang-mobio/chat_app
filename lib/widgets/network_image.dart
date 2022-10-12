import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

networkImages({required String link, BoxFit? fit}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      imageUrl: link,
      fit: fit ?? BoxFit.fill,
      placeholder: (context, url) => const SizedBox(child: CircularProgressIndicator()),
    ),
  );
}


videoThumbNail({required String link}) async {
  return SizedBox();
  // final fileName = await VideoThumbnail.thumbnailFile(
  //   video: link,
  //   thumbnailPath: (await getTemporaryDirectory()).path,
  //   imageFormat: ImageFormat.WEBP,
  //   maxHeight: 64,
  //   quality: 75,
  // );
  // if(fileName != null) {
  //   final file = File(fileName);
  //   return Image.file(file);
  // }
}