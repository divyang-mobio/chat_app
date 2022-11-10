import '../resources/resource.dart';
import '../models/status_model.dart';
import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";

class StatusViewScreen extends StatefulWidget {
  const StatusViewScreen({Key? key, required this.statusModel})
      : super(key: key);

  final StatusModel statusModel;

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  final controller = StoryController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoryView(
      storyItems: widget.statusModel.image
          .map((e) {
            if (e.date.difference(DateTime.now()).inHours >= -24) {
              if (e.type == SendDataType.image) {
                return StoryItem.pageImage(url: e.url, controller: controller);
              } else if (e.type == SendDataType.video) {
                return StoryItem.pageVideo(e.url, controller: controller);
              }
            }
          })
          .whereType<StoryItem>()
          .toList(),
      controller: controller,
      onStoryShow: (s) {},
      onComplete: () {
        Navigator.pop(context);
      },
      onVerticalSwipeComplete: (direction) {
        if (direction == Direction.down) {
          Navigator.pop(context);
        }
      },
    );
  }
}
