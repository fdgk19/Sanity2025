import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
import 'package:universal_html/js.dart' as js;
import 'package:universal_html/html.dart' as html;
import 'package:sanity_web/presentations/widgets/create_post_widgets/ui_texteditor.dart'
    as ui;

import 'package:sanity_web/presentations/widgets/create_post_widgets/item_create_button.dart';
import 'package:zefyrka/zefyrka.dart';

class EditSectionTablet extends StatefulWidget {
  final int index;
  const EditSectionTablet({super.key, required this.index});

  @override
  State<EditSectionTablet> createState() => _EditSectionTabletState();
}

class _EditSectionTabletState extends State<EditSectionTablet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  String tempSectionId = "";
  String? imgUrl;
  String? audioUrl;
  String? videoUrl;
  String? editText;
  String? youtubeUrl;
  String? signature;
  String? mediaName;

  TextEditingController signatureController = TextEditingController();

  bool isPreviewActive = false;
  bool showiFrame = false;

  bool isLoading = false;
  bool needAbsorbe = false;

  ZefyrController editorController = ZefyrController();

  String createdViewId = Random().nextInt(1000).toString();
  late js.JsObject connector;
  late html.IFrameElement element;

  InputCreateType inputType = InputCreateType.none;

  Offset? _tapSectionMediaPosition;

  final _formKey = GlobalKey<FormState>();

  SectionModel? previousSectionVersion;
  List<SectionMediaModel> tempMedia = [];

  @override
  void initState() {
    _tapSectionMediaPosition = const Offset(0, 0);

    js.context["connect_content_to_flutter"] = (js.JsObject content) {
      connector = content;
    };
    element = html.IFrameElement()
      ..src = "/lib/resources/webview/editor.html"
      ..style.border = 'none';

    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => element);

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
                    image: AssetImage(
                      "lib/resources/images/background.png",
                    ),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            constraints: const BoxConstraints(
                maxHeight: 800, maxWidth: 900, minHeight: 70, minWidth: 900),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 13.0, bottom: 7),
                    child: Form(
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
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  Center(
                    child: Wrap(
                      children: [
                        //parte sinsitra

                        SizedBox(
                          width: 200,
                          child: Wrap(
                            children: [
                              //add bottoni
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (inputType == InputCreateType.text) {
                                          setState(() {
                                            inputType = InputCreateType.none;
                                          });
                                        } else {
                                          setState(() {
                                            inputType = InputCreateType.text;
                                          });
                                        }
                                      },
                                      child: ItemCreateButton(
                                          icon: Icons.title, text: tr("text")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (inputType !=
                                            InputCreateType.video) {
                                          setState(() {
                                            inputType = InputCreateType.none;
                                          });
                                          var file = await fileFromStorage(
                                              videoExtSupported);
                                          if (file == null && mounted) {
                                            showerrortoast(
                                                tr("error_dimension_video"),
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
                                                      "video${file.name}",
                                                      InputCreateType.video);
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
                                            inputType = InputCreateType.none;
                                          });
                                        }
                                      },
                                      child: ItemCreateButton(
                                        icon: Icons.video_file_rounded,
                                        text: tr("add_video"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (inputType == InputCreateType.url) {
                                          setState(() {
                                            inputType = InputCreateType.none;
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (inputType !=
                                            InputCreateType.image) {
                                          setState(() {
                                            inputType = InputCreateType.none;
                                          });
                                          var file = await uploadImage(
                                            context,
                                            DeviceScreenType.tablet,
                                          );
                                          if (file == null && mounted) {
                                            showerrortoast(
                                                tr("error_dimension"), context);
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
                                                      InputCreateType.image);
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
                                                      InputCreateType.image;
                                                });
                                              }
                                            }
                                          } else {}
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                            inputType = InputCreateType.none;
                                          });
                                        }
                                      },
                                      child: ItemCreateButton(
                                          icon: Icons.image,
                                          text: tr("add_image")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (inputType !=
                                            InputCreateType.audio) {
                                          setState(() {
                                            inputType = InputCreateType.none;
                                          });
                                          var file = await fileFromStorage(
                                              audioExtSupported);
                                          if (file == null && mounted) {
                                            showerrortoast(
                                                tr("error_dimension"), context);
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
                                                      InputCreateType.audio);
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
                                            inputType = InputCreateType.none;
                                          });
                                        }
                                      },
                                      child: ItemCreateButton(
                                          icon: Icons.multitrack_audio_outlined,
                                          text: tr("add_audio")),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (inputType ==
                                            InputCreateType.signature) {
                                          setState(() {
                                            inputType = InputCreateType.none;
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
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 8, bottom: 8, right: 8),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        tr("preview_section_element"),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: 450,
                                      // MediaQuery.of(context).size.width *
                                      //     0.40,
                                      height: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Consumer<NewPostProvider>(builder:
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
                                                return Column(
                                                  children: [
                                                    ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: provider
                                                            .sectionList[
                                                                widget.index]
                                                            .sectionMediaList!
                                                            .length,
                                                        itemBuilder: (context,
                                                                index) =>
                                                            SectionElementItemTablet(
                                                                needAbsorbe:
                                                                    needAbsorbe,
                                                                media: provider
                                                                        .sectionList[widget
                                                                            .index]
                                                                        .sectionMediaList![
                                                                    index],
                                                                isReadOnly:
                                                                    false,
                                                                onMediaTapDown:
                                                                    _storeSectionMediaPosition,
                                                                onMediaTap:
                                                                    () async {
                                                                  if (provider
                                                                          .sectionList[
                                                                              widget.index]
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
                                                                })),
                                                  ],
                                                );
                                              }
                                            }),
                                            inputType == InputCreateType.none
                                                ? const SizedBox.shrink()
                                                : SizedBox(
                                                    height: inputType ==
                                                            InputCreateType
                                                                .audio
                                                        ? 120
                                                        : 250,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius.all(
                                                                          Radius.circular(
                                                                              6)),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.7),
                                                                      width:
                                                                          0.2)),
                                                              child:
                                                                  buildInputBody(
                                                                      context)),
                                                        ),
                                                        Positioned(
                                                          right: 5,
                                                          top: 5,
                                                          child: MaterialButton(
                                                              minWidth: 120,
                                                              elevation: 5,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0)),
                                                              color:
                                                                  Colors.white,
                                                              child: Text(
                                                                tr("added"),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        13),
                                                              ),
                                                              onPressed: () {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  if (inputType !=
                                                                      InputCreateType
                                                                          .none) {
                                                                    if (inputType ==
                                                                        InputCreateType
                                                                            .text) {
                                                                      //editText = getMessageHtml();
                                                                      editText =
                                                                          json.encode(
                                                                              editorController.document);
                                                                    }
                                                                    if (inputType ==
                                                                        InputCreateType
                                                                            .signature) {
                                                                      signature =
                                                                          signatureController
                                                                              .text;
                                                                    }
                                                                    var tempContent = editText ??
                                                                        imgUrl ??
                                                                        videoUrl ??
                                                                        audioUrl ??
                                                                        youtubeUrl ??
                                                                        signature ??
                                                                        "W Franco";
                                                                    if (!context
                                                                        .read<
                                                                            NewPostProvider>()
                                                                        .sectionList
                                                                        .any((element) =>
                                                                            element.sid ==
                                                                            tempSectionId)) {
                                                                      context.read<NewPostProvider>().addSection(SectionModel(
                                                                          sid:
                                                                              tempSectionId,
                                                                          title:
                                                                              titleController.text));
                                                                    }
                                                                    context.read<NewPostProvider>().addMediaSection(
                                                                        widget
                                                                            .index,
                                                                        SectionMediaModel(
                                                                            mediaType:
                                                                                inputType,
                                                                            mediaContent:
                                                                                tempContent,
                                                                            mediaName:
                                                                                mediaName));
                                                                    resetForm();
                                                                  }
                                                                }
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    isLoading
                                        ? Container(
                                            width: 450,
                                            height: 300,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 46, 46, 46)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: LoadingAnimationWidget.beat(
                                              color: const Color.fromARGB(
                                                  255, 255, 177, 59),
                                              size: 60,
                                            ))
                                        : const SizedBox.shrink()
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
                                      if (inputType != InputCreateType.none) {
                                        if (inputType == InputCreateType.text) {
                                          //editText = getMessageHtml();
                                          editText = json.encode(
                                              editorController.document);
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
                                          signature = signatureController.text;
                                        }
                                        if (inputType == InputCreateType.url &&
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
                                                element.sid == tempSectionId)) {
                                          context
                                              .read<NewPostProvider>()
                                              .addSection(SectionModel(
                                                  sid: tempSectionId,
                                                  title: titleController.text));
                                        }
                                        context
                                            .read<NewPostProvider>()
                                            .addMediaSection(
                                                widget.index,
                                                SectionMediaModel(
                                                    mediaType: inputType,
                                                    mediaContent: tempContent,
                                                    mediaName: mediaName));
                                        resetForm();
                                      }
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]))));
  }

  Widget buildInputBody(BuildContext context) {
    switch (inputType) {
      case InputCreateType.image:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.38,
            height: 140,
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
          padding: const EdgeInsets.only(top: 50.0),
          child: SizedBox(
            width: 300,
            height: 80,
            child: CustomAudioPlayer(audioUrl: audioUrl ?? ""),
          ),
        );
      case InputCreateType.text:
        return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.38,
                height: 240,
                child: Column(
                  children: [
                    ZefyrToolbar.basic(controller: editorController),
                    Expanded(
                      child: ZefyrEditor(
                        autofocus: true,
                        focusNode: FocusNode(),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        controller: editorController,
                      ),
                    ),
                  ],
                )));

      case InputCreateType.url:
        return Column(
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
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.38,
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
                              hintStyle: TextStyle(fontWeight: FontWeight.w500),
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
                      height: 160,
                    ))
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: 120,
                  ),
          ],
        );
      case InputCreateType.video:
        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.38,
              height: 140,
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
            width: MediaQuery.of(context).size.width * 0.38,
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
            width: MediaQuery.of(context).size.width * 0.38,
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

  String getMessageHtml() {
    final String body = connector.callMethod('getValue') as String;
    return body;
  }

  void resetForm() {
    setState(() {
      inputType = InputCreateType.none;
      imgUrl = null;
      videoUrl = null;
      audioUrl = null;
      youtubeUrl = null;
      editText = null;
      mediaName = null;
      urlController.text = "";
      urlController.text = "";
      signatureController = TextEditingController();
      editorController = ZefyrController();
    });
  }

  void _storeSectionMediaPosition(TapDownDetails details) {
    double tapDy = (details.globalPosition.dy);
    double tapDx = (details.globalPosition.dx + 0);
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
}
