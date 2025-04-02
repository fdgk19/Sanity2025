
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/data/models/section_media_model.dart';
import 'package:sanity_web/data/models/section_model.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/audio_player.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/section_element_item.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/video_player.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/youtube_player.dart';


class EditSectionDesktop extends StatefulWidget {
  final int index;
  const EditSectionDesktop({super.key, required this.index});

  @override
  State<EditSectionDesktop> createState() => _EditSectionDesktopState();
}

class _EditSectionDesktopState extends State<EditSectionDesktop> {
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String tempSectionId = "";
  String? imgUrl;
  String? audioUrl;
  String? videoUrl;
  String? editText;
  String? youtubeUrl;
  String? signature;
  String? mediaName;

  TextEditingController signatureController = TextEditingController();

  Offset? _tapSectionMediaPosition;

  bool isLoading = false;
  bool isPreviewActive = false;
  bool showiFrame = false;

  InputCreateType inputType = InputCreateType.none;

  final _formKey = GlobalKey<FormState>();

  SectionModel? previousSectionVersion;
  List<SectionMediaModel> tempMedia = [];

  @override
  void initState() {
    _tapSectionMediaPosition = const Offset(0, 0);
    previousSectionVersion =
        Provider.of<NewPostProvider>(context, listen: false)
            .getSectionForEdit();
    tempSectionId = previousSectionVersion!.sid;
    titleController.text = previousSectionVersion!.title;
    tempMedia = previousSectionVersion!.sectionMediaList!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/resources/images/background.png"),
                fit: BoxFit.fill),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        constraints: const BoxConstraints(
            minHeight: 70, maxHeight: 900, minWidth: 1000, maxWidth: 1000),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 13.0, bottom: 7, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topRight: Radius.circular(8))),
                        child: SizedBox(
                            height: 37,
                            width: 270,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return tr("enter_valid_title");
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: titleController,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 8, left: 10),
                                    hintStyle: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    border: InputBorder.none,
                                    hintText: tr("insert_title_section"),
                                  )),
                            )),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              child: Text(tr("back")),
                              onPressed: () async {
                                if (context
                                    .read<NewPostProvider>()
                                    .sectionList
                                    .isNotEmpty) {
                                  await context
                                      .read<NewPostProvider>()
                                      .abortEditSection(
                                          SectionModel(
                                              sid: tempSectionId,
                                              title: titleController.text,
                                              sectionMediaList: tempMedia),
                                          widget.index);
                                }
                                if (mounted) {
                                  AutoRouter.of(context).pop();
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: ElevatedButton(
                              child: Text(tr("edit_section")),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  var tempSectionList = context
                                      .read<NewPostProvider>()
                                      .sectionList;
                                  if (widget.index == tempSectionList.length) {
                                    AutoRouter.of(context).pop(false);
                                  } else if (tempSectionList[widget.index]
                                          .sectionMediaList !=
                                      null) {
                                    context
                                        .read<NewPostProvider>()
                                        .updateSectionTitle(SectionModel(
                                            sid: tempSectionId,
                                            title: titleController.text,
                                            sectionMediaList: tempMedia));
                                    AutoRouter.of(context).pop(true);
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: contentController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: tr("insert_content_section"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr("add_media"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.image, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              inputType = InputCreateType.image;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.video_library,
                              color: Colors.white),
                          onPressed: () {
                            setState(() {
                              inputType = InputCreateType.video;
                            });
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.audio_file, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              inputType = InputCreateType.audio;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.youtube_searched_for,
                              color: Colors.white),
                          onPressed: () {
                            setState(() {
                              inputType = InputCreateType.url;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (inputType != InputCreateType.none)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      controller: urlController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: tr("enter_url"),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              if (inputType != InputCreateType.none)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            inputType = InputCreateType.none;
                            urlController.clear();
                          });
                        },
                        child: Text(tr("cancel")),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (urlController.text.isNotEmpty) {
                            setState(() {
                              tempMedia.add(
                                SectionMediaModel(
                                  mediaType: inputType,
                                  mediaContent: urlController.text,
                                  mediaName: "",
                                ),
                              );
                              inputType = InputCreateType.none;
                              urlController.clear();
                            });
                          }
                        },
                        child: Text(tr("add")),
                      ),
                    ],
                  ),
                ),
              if (tempMedia.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tempMedia.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: SectionElementItem(
                          media: tempMedia[index],
                          isReadOnly: false,
                          onMediaTapDown: (details) {
                            setState(() {
                              _tapSectionMediaPosition = details.globalPosition;
                            });
                          },
                          onMediaTap: () {
                            setState(() {
                              tempMedia.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputBody(BuildContext context) {
    switch (inputType) {
      case InputCreateType.image:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            width: 450,
            height: 260,
            child: imgUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Image.network(
                      imgUrl!,
                      fit: BoxFit.fill,
                    ),
                  )
                : Center(
                    child: Text(tr("img_error")),
                  ),
          ),
        );
      case InputCreateType.audio:
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SizedBox(
            width: 460,
            height: 80,
            child: CustomAudioPlayer(audioUrl: audioUrl ?? ""),
          ),
        );
      case InputCreateType.text:
        return Container(
            color: Colors.white,
            width: 450,
            height: 260,
            child: TextFormField(
              controller: contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: tr("insert_content_section"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ));
      case InputCreateType.url:
        return SizedBox(
          width: 475,
          height: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text(
                      tr("insert_url"),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.3),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    child: SizedBox(
                        height: 37,
                        width: 320,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  youtubeUrl = value;
                                  showiFrame = false;
                                });
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  setState(() {
                                    showiFrame = true;
                                  });
                                });
                              } else {
                                setState(() {
                                  youtubeUrl = null;
                                  showiFrame = false;
                                });
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  youtubeUrl = value;
                                  showiFrame = false;
                                });
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  setState(() {
                                    showiFrame = true;
                                  });
                                });
                              } else {
                                setState(() {
                                  youtubeUrl = null;
                                  showiFrame = false;
                                });
                              }
                            },
                            controller: urlController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, left: 10),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                hintText: ""),
                          ),
                        )),
                  ),
                ],
              ),
              showiFrame
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: YoutubePlayerItem(
                        url: urlController.text,
                        height: 199,
                      ))
                  : const SizedBox(
                      width: 350,
                      height: 200,
                    ),
            ],
          ),
        );
      case InputCreateType.video:
        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SizedBox(
              width: 350,
              height: 200,
              child: CustomVideoPlayer(
                urlVideo: videoUrl ?? "",
              )),
        );
      case InputCreateType.signature:
        return Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 8, left: 10),
                hintStyle: const TextStyle(fontWeight: FontWeight.w500),
                border: InputBorder.none,
                hintText: tr("SanityApp"),
              ),
              controller: signatureController,
              style: const TextStyle(fontFamily: 'Signatrue', fontSize: 25),
            ));
      case InputCreateType.none:
        return SizedBox(
            width: 250,
            height: 240,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                tr("empty_section"),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )));
      default:
        return SizedBox(
            width: 250,
            height: 240,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  tr("empty_section"),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ));
    }
  }

  void resetForm() {
    setState(() {
      inputType = InputCreateType.none;
      imgUrl = null;
      videoUrl = null;
      audioUrl = null;
      youtubeUrl = null;
      editText = null;
      urlController.text = "";
      signature = null;
      mediaName = null;
      signatureController = TextEditingController();
    });
  }

  void _storeSectionMediaPosition(TapDownDetails details) {
    double tapDy = (details.globalPosition.dy);
    double tapDx = (details.globalPosition.dx + 50);
    _tapSectionMediaPosition = Offset(tapDx, tapDy);
    //_tapSectionMediaPosition = details.globalPosition;
  }

  _showSectionMediaPopupMenuOnlyRemove(
      BuildContext context, int mediaIndex) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu<int>(
      constraints: const BoxConstraints(maxWidth: 56),
      context: context,
      position: RelativeRect.fromRect(
          _tapSectionMediaPosition! &
              const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        const PopupMenuItem<int>(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.delete)],
            )),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value != null) {
        switch (value) {
          case 1:
            context
                .read<NewPostProvider>()
                .removeSectionMedia(widget.index, mediaIndex, false, true);
            break;
        }
      }
    });
  }

  _showSectionMediaPopupMenu(BuildContext context, int mediaIndex) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu<int>(
      constraints: const BoxConstraints(maxWidth: 56),
      context: context,
      position: RelativeRect.fromRect(
          _tapSectionMediaPosition! &
              const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        const PopupMenuItem<int>(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.delete)],
            )),
        const PopupMenuItem<int>(
            value: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.arrow_upward)],
            )),
        const PopupMenuItem<int>(
            value: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.arrow_downward)],
            )),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value != null) {
        switch (value) {
          case 1:
            context
                .read<NewPostProvider>()
                .removeSectionMedia(widget.index, mediaIndex, false, true);
            break;
          case 2:
            context
                .read<NewPostProvider>()
                .moveUpSectionMedia(widget.index, mediaIndex);
            break;
          case 3:
            context
                .read<NewPostProvider>()
                .moveDownSectionMedia(widget.index, mediaIndex);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    urlController.dispose();
    contentController.dispose();
    signatureController.dispose();
    super.dispose();
  }
}
