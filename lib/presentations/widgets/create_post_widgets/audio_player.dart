import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String audioUrl;
  const CustomAudioPlayer({super.key, required this.audioUrl});

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    // setAudio();
    if (mounted) {
      _player.onPlayerStateChanged.listen((event) {
        setState(() {
          isPlaying = event == PlayerState.playing;
        });
      });
      
      _player.onDurationChanged.listen((newDuration) {
        setState(() {
          duration = newDuration;
        });
      });
      
      _player.onPositionChanged.listen((newPosition) {
        setState(() {
          position = newPosition;
        });
      });
    }

    super.initState();
  }

  // @override
  // void dispose() {
  //   if (mounted) {
  //     _player.stop();
  //     _player.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 32, 32, 32),
                  Color.fromARGB(255, 75, 75, 75)
                ],
              )),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () async {
                    // setState(() {
                    //   isPlaying = !isPlaying;
                    // }
                    if (isPlaying) {
                      await _player.pause();
                    } else {
                      await _player.play(UrlSource(widget.audioUrl));
                    }
                    
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  )),
              Expanded(
                child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: ((value) async {
                      final position = Duration(seconds: value.toInt());
                      await _player.seek(position);
                    })),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
