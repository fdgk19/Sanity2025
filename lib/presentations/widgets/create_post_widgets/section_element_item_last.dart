
import 'package:flutter/material.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/data/models/section_media_model.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/audio_player.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/video_player.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/youtube_player.dart';

class SectionElementItemLast extends StatefulWidget {
  final SectionMediaModel media;
  final Function(TapDownDetails) onMediaTapDown;
  final Function() onMediaTap;
  final bool isReadOnly;
  const SectionElementItemLast(
      {super.key,
      required this.media,
      required this.onMediaTapDown,
      required this.onMediaTap,
      required this.isReadOnly});

  @override
  State<SectionElementItemLast> createState() => _SectionElementItemLastState();
}

class _SectionElementItemLastState extends State<SectionElementItemLast> {
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    if (widget.media.mediaType == InputCreateType.text) {
      contentController.text = widget.media.mediaContent;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: SizedBox(
        width: 280,
        child: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                child: mediaWidgetDesktop(context)),
            Positioned(
              right: 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTapDown: (details) {
                        widget.onMediaTapDown(details);
                      },
                      onTap: () {
                        widget.onMediaTap();
                      },
                      child: Icon(
                        Icons.menu,
                        size: 12,
                        color: Colors.black.withOpacity(1),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget mediaWidgetDesktop(BuildContext context) {
    switch (widget.media.mediaType) {
      case InputCreateType.image:
        return SizedBox(
            height: 260, child: Image.network(widget.media.mediaContent));
      case InputCreateType.audio:
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: SizedBox(
            height: 60,
            child: CustomAudioPlayer(audioUrl: widget.media.mediaContent),
          ),
        );
      case InputCreateType.text:
        return TextFormField(
          controller: contentController,
          readOnly: true,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "Contenuto",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        );
      case InputCreateType.url:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: YoutubePlayerItem(
            url: widget.media.mediaContent,
            height: 260,
          ),
        );
      case InputCreateType.video:
        return SizedBox(
            height: 260,
            child: CustomVideoPlayer(urlVideo: widget.media.mediaContent));
      case InputCreateType.signature:
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Text(
                  widget.media.mediaContent,
                  style: const TextStyle(fontFamily: 'Signatrue', fontSize: 25),
                ),
              ),
            ],
          ),
        );
      case InputCreateType.none:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}

class SectionElementItemLastMobile extends StatefulWidget {
  final SectionMediaModel media;
  final Function(TapDownDetails) onMediaTapDown;
  final Function() onMediaTap;
  final bool isReadOnly;
  const SectionElementItemLastMobile(
      {super.key,
      required this.media,
      required this.onMediaTapDown,
      required this.onMediaTap,
      required this.isReadOnly});

  @override
  State<SectionElementItemLastMobile> createState() =>
      _SectionElementItemLastMobileState();
}

class _SectionElementItemLastMobileState
    extends State<SectionElementItemLastMobile> {
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    if (widget.media.mediaType == InputCreateType.text) {
      contentController.text = widget.media.mediaContent;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: SizedBox(
        width: 280,
        child: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                child: mediaWidgetMobile(context)),
            Positioned(
              right: 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTapDown: (details) {
                        widget.onMediaTapDown(details);
                      },
                      onTap: () {
                        widget.onMediaTap();
                      },
                      child: Icon(
                        Icons.menu,
                        size: 12,
                        color: Colors.black.withOpacity(1),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget mediaWidgetMobile(BuildContext context) {
    switch (widget.media.mediaType) {
      case InputCreateType.image:
        return SizedBox(
            height: 260, child: Image.network(widget.media.mediaContent));
      case InputCreateType.audio:
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: SizedBox(
            height: 60,
            child: CustomAudioPlayer(audioUrl: widget.media.mediaContent),
          ),
        );
      case InputCreateType.text:
        return TextFormField(
          controller: contentController,
          readOnly: true,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "Contenuto",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        );
      case InputCreateType.url:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: YoutubePlayerItem(
            url: widget.media.mediaContent,
            height: 260,
          ),
        );
      case InputCreateType.video:
        return SizedBox(
            height: 260,
            child: CustomVideoPlayer(urlVideo: widget.media.mediaContent));
      case InputCreateType.signature:
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Text(
                  widget.media.mediaContent,
                  style: const TextStyle(fontFamily: 'Signatrue', fontSize: 25),
                ),
              ),
            ],
          ),
        );
      case InputCreateType.none:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}

class SectionElementItemLastTablet extends StatefulWidget {
  final SectionMediaModel media;
  final Function(TapDownDetails) onMediaTapDown;
  final Function() onMediaTap;
  final bool isReadOnly;
  const SectionElementItemLastTablet(
      {super.key,
      required this.media,
      required this.onMediaTapDown,
      required this.onMediaTap,
      required this.isReadOnly});

  @override
  State<SectionElementItemLastTablet> createState() =>
      _SectionElementItemLastTabletState();
}

class _SectionElementItemLastTabletState
    extends State<SectionElementItemLastTablet> {
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    if (widget.media.mediaType == InputCreateType.text) {
      contentController.text = widget.media.mediaContent;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: SizedBox(
        width: 280,
        child: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                child: mediaWidgetTablet(context)),
            Positioned(
              right: 1,
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTapDown: (details) {
                        widget.onMediaTapDown(details);
                      },
                      onTap: () {
                        widget.onMediaTap();
                      },
                      child: Icon(
                        Icons.menu,
                        size: 12,
                        color: Colors.black.withOpacity(1),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget mediaWidgetTablet(BuildContext context) {
    switch (widget.media.mediaType) {
      case InputCreateType.image:
        return SizedBox(
            height: 260, child: Image.network(widget.media.mediaContent));
      case InputCreateType.audio:
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: SizedBox(
            height: 60,
            child: CustomAudioPlayer(audioUrl: widget.media.mediaContent),
          ),
        );
      case InputCreateType.text:
        return TextFormField(
          controller: contentController,
          readOnly: true,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "Contenuto",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        );
      case InputCreateType.url:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: YoutubePlayerItem(
            url: widget.media.mediaContent,
            height: 260,
          ),
        );
      case InputCreateType.video:
        return SizedBox(
            height: 260,
            child: CustomVideoPlayer(urlVideo: widget.media.mediaContent));
      case InputCreateType.signature:
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Text(
                  widget.media.mediaContent,
                  style: const TextStyle(fontFamily: 'Signatrue', fontSize: 25),
                ),
              ),
            ],
          ),
        );
      case InputCreateType.none:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}
