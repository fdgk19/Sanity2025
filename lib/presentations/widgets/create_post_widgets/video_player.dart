import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String urlVideo;
  const CustomVideoPlayer({Key? key, required this.urlVideo}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.network(
        widget.urlVideo,
        ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickVideoWithControls: FlickVideoWithControls(
        playerLoadingFallback: Positioned.fill(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 10,
                    top: 10,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child:LoadingAnimationWidget.beat(
                              color: const Color.fromARGB(255, 255, 177, 59),
                              size: 40,
                          ),
                    ),
                  ),
                ],
              ),
              ),
              videoFit: BoxFit.fill,
              controls: FlickPortraitControls(
                progressBarSettings:
                    FlickProgressBarSettings(playedColor: Colors.red),
              ),),
      flickManager: flickManager);
  }
}
