import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerItem extends StatefulWidget {
  final String url;
  final double height;
  const YoutubePlayerItem({super.key, required this.url, required this.height});

  @override
  State<YoutubePlayerItem> createState() => _YoutubePlayerItemState();
}

class _YoutubePlayerItemState extends State<YoutubePlayerItem> {
  YoutubePlayerController? _controller;
  String videoId = "";

  @override
  void initState() {
    bool autoPlay = false;
    if (mounted) {
      autoPlay = false;
      videoId = widget.url.split('?v=').last;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller = YoutubePlayerController(
            params: const YoutubePlayerParams(
              showControls: true,
              mute: false,
              showFullscreenButton: true,
              loop: false,
            ))
            ..onInit = () async {
              if(autoPlay) {
                await _controller!.loadVideoById(videoId: videoId, startSeconds: 0);
              } else {
                await _controller!.cueVideoById(videoId: videoId, startSeconds: 0);
              }
            }
            ..onFullscreenChange = (isFullScreen) {};
        setState(() {});
      });
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   _controller!.close();
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    return _controller == null
    ? Center(
          child: LoadingAnimationWidget.beat(
        color: const Color.fromARGB(255, 255, 177, 59),
        size: 60,
      ))
    : YoutubePlayerScaffold(
      autoFullScreen: false,
      aspectRatio: 16 / 9,
      controller: _controller!,
      builder: (context, player) {
        return SizedBox(
          width: 460,
          height: widget.height,
          child: player,
        );
      },
    );
  }
}
