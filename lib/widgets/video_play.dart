import '../resources/resource.dart';
import '../controllers/video_player_bloc/play_pause_bloc.dart';
import '../controllers/video_player_bloc/refresh_bloc.dart';
import '../controllers/video_player_bloc/visible_container_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  VideoAppState createState() => VideoAppState();
}

class VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool isVis = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        BlocProvider.of<RefreshBloc>(context).add(RefreshVideo());
      });
  }

  Icon playIcon(IconData iconData) {
    return Icon(
      iconData,
      size: 40,
      color: ColorResources().videoPlayIconText,
    );
  }

  format(Duration d) => d.toString().substring(2, 7);

  IconButton playButton() {
    return IconButton(
      onPressed: () =>
          BlocProvider.of<PlayPauseBloc>(context)
              .add(PlayPause(controller: _controller)),
      icon: BlocBuilder<PlayPauseBloc, PlayPauseState>(
        builder: (context, state) {
          if (state is PlayPauseLoaded) {
            return playIcon(state.isPlay
                ? IconResources().videoPause
                : IconResources().videoPlay);
          } else {
            return playIcon(IconResources().videoPlay);
          }
        },
      ),
    );
  }

  BlocBuilder bottomContainer() {
    return BlocBuilder<VisibleContainerBloc, VisibleContainerState>(
      builder: (context, state) {
        if (state is VisibleContainerShow) {
          return Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: state.isVis,
                child: Container(
                  color: ColorResources().videoPlayContainer,
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                      playedColor:
                                      Theme
                                          .of(context)
                                          .primaryColor),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(format(_controller.value.duration),
                                  style: TextStyle(
                                      color:
                                      ColorResources().videoPlayIconText))
                            ]),
                      ),
                      playButton()
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox(height: 1);
        }
      },
    );
  }

  Align backNavigator() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(IconResources().navigationBack)),
    );
  }

  showVideoFunction() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            BlocProvider.of<VisibleContainerBloc>(context)
                .add(ShowContainer(isVis: isVis));
            isVis = !isVis;
          },
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: BlocBuilder<RefreshBloc, RefreshState>(
              builder: (context, state) {
                if (state is RefreshLoaded) {
                  return VideoPlayer(_controller);
                } else {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
              },
            ),
          ),
        ),
        bottomContainer(),
        backNavigator(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(child: showVideoFunction()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
