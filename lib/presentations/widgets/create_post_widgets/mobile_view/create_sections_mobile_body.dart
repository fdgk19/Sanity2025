import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/section_media_model.dart';
import 'package:sanity_web/data/models/section_model.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/audio_player.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/section_element_item.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/video_player.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/youtube_player.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/item_create_button.dart';

class AddSectionMobile extends StatefulWidget {
  final int index;
  const AddSectionMobile({super.key, required this.index});

  @override
  State<AddSectionMobile> createState() => _AddSectionMobileState();
}

class _AddSectionMobileState extends State<AddSectionMobile> {
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController signatureController = TextEditingController();

  String tempSectionId = "";
  String? imgUrl;
  String? audioUrl;
  String? videoUrl;
  String? editText;
  String? youtubeUrl;
  String? signature;
  String? mediaName;

  Offset? _tapSectionMediaPosition;

  bool isLoading = false;
  bool isPreviewActive = false;
  bool showiFrame = false;

  InputCreateType inputType = InputCreateType.none;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tapSectionMediaPosition = const Offset(0, 0);
    tempSectionId = firestoreId();
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
                    image: AssetImage(
                      "lib/resources/images/background.png",
                    ),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            constraints: const BoxConstraints(
                maxHeight: 700, maxWidth: 870, minHeight: 700, minWidth: 870),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0, top: 13.0, bottom: 7),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            child: SizedBox(
                                height: 37,
                                width: 220,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPreviewActive = !isPreviewActive;
                                });
                              },
                              child: SvgPicture.asset(
                                !isPreviewActive
                                    ? "lib/resources/images/eye-off-lined.svg"
                                    : "lib/resources/images/eye-lined.svg",
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 20),
                    child: Wrap(
                      children: [
                        //parte sinsitra
                        //tutti i tasti
                        !isPreviewActive
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //add bottoni
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (inputType ==
                                                InputCreateType.text) {
                                              setState(() {
                                                inputType =
                                                    InputCreateType.none;
                                              });
                                            } else {
                                              setState(() {
                                                inputType =
                                                    InputCreateType.text;
                                              });
                                            }
                                          },
                                          child: ItemCreateButton(
                                              icon: Icons.title,
                                              text: tr("text")),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (inputType !=
                                                InputCreateType.video) {
                                              setState(() {
                                                inputType =
                                                    InputCreateType.none;
                                              });
                                              var file = await fileFromStorage(
                                                  videoExtSupported);
                                              if (file == null && mounted) {}
                                              if (file != null) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                if (mounted) {
                                                  var uploadResult = await context
                                                      .read<NewPostProvider>()
                                                      .uploadSectionMedia(
                                                          file,
                                                          tempSectionId,
                                                          "video${file.name}",
                                                          InputCreateType
                                                              .video);
                                                  if (uploadResult == null &&
                                                      mounted) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showerrortoast(
                                                        tr("error_upload"),
                                                        context);
                                                  } else {
                                                    videoUrl = uploadResult;
                                                    mediaName = file.name;
                                                    setState(() {
                                                      isLoading = false;
                                                      inputType =
                                                          InputCreateType.video;
                                                    });
                                                  }
                                                }
                                              } else {}
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                                inputType =
                                                    InputCreateType.none;
                                              });
                                            }
                                          },
                                          child: ItemCreateButton(
                                            icon: Icons.video_file_rounded,
                                            text: tr("add_video"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (inputType !=
                                                  InputCreateType.image) {
                                                setState(() {
                                                  inputType =
                                                      InputCreateType.none;
                                                });
                                                var file = await uploadImage(
                                                  context,
                                                  DeviceScreenType.mobile,
                                                );

                                                if (file == null && mounted) {
                                                  showerrortoast(
                                                      tr("error_dimension"),
                                                      context);
                                                }
                                                if (file != null) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  if (mounted) {
                                                    var uploadResult = await context
                                                        .read<NewPostProvider>()
                                                        .uploadSectionMedia(
                                                            file,
                                                            tempSectionId,
                                                            "image${file.name}",
                                                            InputCreateType
                                                                .image);
                                                    if (uploadResult == null &&
                                                        mounted) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      showerrortoast(
                                                          tr("error_upload"),
                                                          context);
                                                    } else {
                                                      imgUrl = uploadResult;
                                                      mediaName = file.name;
                                                      setState(() {
                                                        isLoading = false;
                                                        inputType =
                                                            InputCreateType
                                                                .image;
                                                      });
                                                    }
                                                  }
                                                } else {}
                                              } else {
                                                setState(() {
                                                  isLoading = false;
                                                  inputType =
                                                      InputCreateType.none;
                                                });
                                              }
                                            },
                                            child: ItemCreateButton(
                                                icon: Icons.image,
                                                text: tr("add_image")),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (inputType ==
                                                  InputCreateType.signature) {
                                                setState(() {
                                                  inputType =
                                                      InputCreateType.none;
                                                });
                                              } else {
                                                setState(() {
                                                  inputType =
                                                      InputCreateType.signature;
                                                });
                                              }
                                            },
                                            child: ItemCreateButton(
                                              icon: Icons.draw,
                                              text: tr("signature"),
                                            ),
                                          )
                                        ]),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (inputType ==
                                                InputCreateType.url) {
                                              setState(() {
                                                inputType =
                                                    InputCreateType.none;
                                              });
                                            } else {
                                              setState(() {
                                                inputType = InputCreateType.url;
                                              });
                                            }
                                          },
                                          child: ItemCreateButton(
                                            icon: Icons.video_collection,
                                            text: tr("add_youtube_url"),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (inputType !=
                                                InputCreateType.audio) {
                                              setState(() {
                                                inputType =
                                                    InputCreateType.none;
                                              });
                                              var file = await fileFromStorage(
                                                  audioExtSupported);
                                              if (file == null && mounted) {
                                                showerrortoast(
                                                    tr("error_dimension"),
                                                    context);
                                              }
                                              if (file != null) {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                if (mounted) {
                                                  var uploadResult = await context
                                                      .read<NewPostProvider>()
                                                      .uploadSectionMedia(
                                                          file,
                                                          tempSectionId,
                                                          "audio${file.name}",
                                                          InputCreateType
                                                              .audio);
                                                  if (uploadResult == null &&
                                                      mounted) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    showerrortoast(
                                                        tr("error_upload"),
                                                        context);
                                                  } else {
                                                    audioUrl = uploadResult;
                                                    mediaName = file.name;
                                                    setState(() {
                                                      isLoading = false;
                                                      inputType =
                                                          InputCreateType.audio;
                                                    });
                                                  }
                                                }
                                              } else {}
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                                inputType =
                                                    InputCreateType.none;
                                              });
                                            }
                                          },
                                          child: ItemCreateButton(
                                              icon: Icons
                                                  .multitrack_audio_outlined,
                                              text: tr("add_audio")),
                                        )
                                      ],
                                    ),
                                  ),
                                  isLoading
                                      ? SizedBox(
                                          width: 350,
                                          height: 240,
                                          child: LoadingAnimationWidget.beat(
                                            color: const Color.fromARGB(
                                                255, 255, 177, 59),
                                            size: 60,
                                          ))
                                      : buildInputBody(context),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (inputType !=
                                              InputCreateType.none) {
                                            if (inputType ==
                                                InputCreateType.text) {
                                              //editText = getMessageHtml();
                                              editText = json.encode(
                                                  contentController.text);
                                              if (editText == null ||
                                                  editText ==
                                                      '[{"insert":"\\n"}]') {
                                                return;
                                              }
                                            }
                                            if (inputType ==
                                                InputCreateType.signature) {
                                              if (signatureController
                                                  .text.isEmpty) {
                                                return;
                                              }
                                              signature =
                                                  signatureController.text;
                                            }
                                            if (inputType ==
                                                    InputCreateType.url &&
                                                urlController.text.isEmpty) {
                                              return;
                                            }
                                            var tempContent = editText ??
                                                imgUrl ??
                                                videoUrl ??
                                                audioUrl ??
                                                youtubeUrl ??
                                                signature ??
                                                "W Franco";
                                            if (!context
                                                .read<NewPostProvider>()
                                                .sectionList
                                                .any((element) =>
                                                    element.sid ==
                                                    tempSectionId)) {
                                              context
                                                  .read<NewPostProvider>()
                                                  .addSection(SectionModel(
                                                      sid: tempSectionId,
                                                      title: titleController
                                                          .text));
                                            }
                                            context
                                                .read<NewPostProvider>()
                                                .addMediaSection(
                                                    widget.index,
                                                    SectionMediaModel(
                                                        mediaType: inputType,
                                                        mediaContent:
                                                            tempContent,
                                                        mediaName: mediaName));
                                            resetForm();
                                          }
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          tr("add_content"),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, right: 8),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 8.0),
                                      child: Text(
                                        tr("preview_section_element"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 280,
                                          height: 400,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: Consumer<NewPostProvider>(
                                              builder:
                                                  (context, provider, child) {
                                            if (provider.sectionList.length ==
                                                widget.index) {
                                              return const SizedBox.shrink();
                                            }
                                            if (provider.loadingMedia ||
                                                provider
                                                        .sectionList[
                                                            widget.index]
                                                        .sectionMediaList ==
                                                    null) {
                                              return const SizedBox.shrink();
                                            } else {
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: provider
                                                      .sectionList[widget.index]
                                                      .sectionMediaList!
                                                      .length,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      SectionElementItemMobile(
                                                          media: provider
                                                                  .sectionList[
                                                                      widget.index]
                                                                  .sectionMediaList![
                                                              index],
                                                          isReadOnly: false,
                                                          onMediaTapDown:
                                                              _storeSectionMediaPosition,
                                                          onMediaTap: () async {
                                                            if (provider
                                                                    .sectionList[
                                                                        widget
                                                                            .index]
                                                                    .sectionMediaList!
                                                                    .length <=
                                                                1) {
                                                              await _showSectionMediaPopupMenuOnlyRemove(
                                                                  context,
                                                                  index);
                                                            } else {
                                                              await _showSectionMediaPopupMenu(
                                                                  context,
                                                                  index);
                                                            }
                                                          }));
                                            }
                                          }),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 1000, minWidth: 1000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        child: Row(
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
                                          .removeSection(widget.index);
                                    }
                                    if (mounted) {
                                      AutoRouter.of(context).pop(false);
                                    }
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: ElevatedButton(
                                  child: Text(tr("add_section")),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      var tempSectionList = context
                                          .read<NewPostProvider>()
                                          .sectionList;
                                      if (widget.index ==
                                          tempSectionList.length) {
                                        AutoRouter.of(context).pop(false);
                                      } else if (tempSectionList[widget.index]
                                              .sectionMediaList !=
                                          null) {
                                        context
                                            .read<NewPostProvider>()
                                            .updateSectionTitle(SectionModel(
                                                sid: tempSectionId,
                                                title: titleController.text));
                                        AutoRouter.of(context).pop();
                                      } else {
                                        AutoRouter.of(context).pop(false);
                                      }
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])));
  }

  Widget buildInputBody(BuildContext context) {
    switch (inputType) {
      case InputCreateType.image:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            width: 260,
            height: 220,
            child: imgUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Image.network(
                      imgUrl!,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: LoadingAnimationWidget.beat(
                          color: const Color.fromARGB(255, 255, 177, 59),
                          size: 60,
                        ));
                      },
                    ),
                  )
                : Center(
                    child: Text(tr("img_error")),
                  ),
          ),
        );
      case InputCreateType.audio:
        return Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: SizedBox(
            width: 300,
            height: 80,
            child: CustomAudioPlayer(audioUrl: audioUrl ?? ""),
          ),
        );
      case InputCreateType.text:
        return Container(
            color: Colors.white,
            width: 350,
            height: 240,
            child: TextFormField(
              controller: contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: tr("insert_text"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ));
      case InputCreateType.url:
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                ),
                child: Text(
                  tr("insert_url"),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
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
                                EdgeInsets.only(bottom: 8, left: 10, right: 10),
                            hintStyle: TextStyle(fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            hintText: ""),
                      ),
                    )),
              ),
              showiFrame
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: YoutubePlayerItem(
                        url: urlController.text,
                        height: 160,
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
              height: 180,
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
                tr("empty_section_mobile"),
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
                  tr("empty_section_mobile"),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ));
    }
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

  void resetForm() {
    setState(() {
      inputType = InputCreateType.none;
      imgUrl = null;
      videoUrl = null;
      audioUrl = null;
      urlController.text = "";
      youtubeUrl = null;
      editText = null;
      signature = null;
      mediaName = null;
      signatureController.clear();
      contentController.clear();
    });
  }
}
