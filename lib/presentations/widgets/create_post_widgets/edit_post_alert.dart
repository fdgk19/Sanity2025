import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/create_sections.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/desktop_view/edit_section_desktop.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/mobile_view/edit_section_mobile.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/tablet_view/edit_section_tablet.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/post_section.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class EditPostAlert extends StatefulWidget {
  final PostModel post;
  final int  sectionLenght;
  const EditPostAlert({super.key, required this.post, required this.sectionLenght});

  @override
  State<EditPostAlert> createState() => _EditPostAlertState();
}

class _EditPostAlertState extends State<EditPostAlert> {
  final _formKey = GlobalKey<FormState>();

  int openedSectionIndex = -1;

  int tempIndex = -1;

  TextEditingController tagController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  Offset? _tapTagPosition;
  Offset? _tapSectionPosition;

  TextEditingController searchController = TextEditingController();
  List<UserModel> searchResult = [];


  Color color = Colors.black.withOpacity(0.0);
  Color textColor = Colors.white.withOpacity(0.0);

  String? imageUploaded;

  List<String> tags = [];

  @override
  void initState() {

    //initDraftInfo
    titleController.text = widget.post.mainTitle;
    tags = widget.post.tags ?? [];
    openedSectionIndex = widget.sectionLenght-1;
    if(widget.post.mainImage != null && widget.post.mainImage!.isNotEmpty){
      imageUploaded = widget.post.mainImage;
    }
    _tapTagPosition = const Offset(0, 0);
    _tapSectionPosition = const Offset(0, 0);
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => AlertDialog(
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
                    maxHeight: 630,
                    maxWidth: 800,
                    minHeight: 70,
                    minWidth: 800),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: sizingInformation.deviceScreenType ==
                                DeviceScreenType.mobile
                            ? const EdgeInsets.fromLTRB(5, 15, 5, 10)
                            : const EdgeInsets.fromLTRB(20, 15, 20, 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr("title_create_post"),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Row(
                              children: [
                                Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: MaterialButton(
                                        minWidth: 20,
                                        mouseCursor: SystemMouseCursors.click,
                                        color: Colors.blue,
                                        onPressed: () {
                                          if (context.read<NewPostProvider>().sectionList.isEmpty) {
                                           showCretinoMessage();
                                          } else {
                                           context.read<NewPostProvider>().saveAndExit(title: titleController.text, mainImageRef: imageUploaded, tags: tags);
                                           AutoRouter.of(context).pop(true);
                                          }
                                        },
                                        child: Text(
                                          tr("save"),
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: ()  {
                                          showClosingMessage();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 23,
                                        ))),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                      Consumer<NewPostProvider>(
                          builder: (bodyContext, provider, child) {
                            return Stack(
                              children: [
                                child!,
                                provider.loading
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(bodyContext)
                                                    .size
                                                    .height /
                                                8),
                                        child: Center(
                                            child: LoadingAnimationWidget.beat(
                                          color: const Color.fromARGB(
                                              255, 255, 177, 59),
                                          size: 60,
                                        )),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            );
                          },
                          child: Padding(
                            padding: sizingInformation.deviceScreenType ==
                                    DeviceScreenType.mobile
                                ? const EdgeInsets.only(left: 10)
                                : const EdgeInsets.only(left: 30),
                            child: Wrap(
                              spacing: 20,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          text: tr("insert_image"),
                                          style: const TextStyle(
                                              color: Colors.white),
                                          children: [
                                            TextSpan(
                                              text: tr("optional_choice"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Stack(
                                        children: [
                                           MouseRegion(
                                                  onEnter: (event) {
                                                    setState(() {
                                                      color = Colors.black
                                                          .withOpacity(0.7);
                                                      textColor = Colors.white;
                                                    });
                                                  },
                                                  onExit: (event) {
                                                    setState(() {
                                                      color = Colors.black
                                                          .withOpacity(0.0);
                                                      textColor = Colors.white
                                                          .withOpacity(0);
                                                    });
                                                  },
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                           var file = await uploadImage(context, sizingInformation.deviceScreenType,);
                                                               if (file == null && mounted) {
                                                            showerrortoast(tr("error_dimension"),context);
                                                          }
                                                      if (file != null && mounted) {
                                                        var tempRef = await context.read<NewPostProvider>().uploadPostMainImage(widget.post.pid, file, "mainImage");
                                                        setState(() {
                                                          imageUploaded = tempRef;
                                                        });
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: sizingInformation
                                                                      .deviceScreenType ==
                                                                  DeviceScreenType
                                                                      .mobile
                                                              ? 150
                                                              : 300,
                                                          height: sizingInformation
                                                                      .deviceScreenType ==
                                                                  DeviceScreenType
                                                                      .mobile
                                                              ? 150
                                                              : 300,
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.transparent,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8))),
                                                          child:
                                                              imageUploaded !=
                                                                      null
                                                                  ? ClipRRect(
                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                      child: Image.network(
                                                                        imageUploaded!,
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                    )
                                                                  : Center(
                                                                      child: Text(
                                                                          tr("img_error")),
                                                                    ),
                                                        ),
                                                        AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                          width: sizingInformation
                                                                      .deviceScreenType ==
                                                                  DeviceScreenType
                                                                      .mobile
                                                              ? 150
                                                              : 300,
                                                          height: sizingInformation
                                                                      .deviceScreenType ==
                                                                  DeviceScreenType
                                                                      .mobile
                                                              ? 150
                                                              : 300,
                                                          decoration: BoxDecoration(
                                                              color: color,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          8))),
                                                          child: Center(
                                                              child: Text(
                                                            tr("modify_image"),
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          tr("insert_title_post"),
                                          style: const TextStyle(
                                              color: Colors.white),
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
                                            width: sizingInformation
                                                        .deviceScreenType ==
                                                    DeviceScreenType.mobile
                                                ? 250
                                                : 300,
                                            child: TextFormField(
                                              controller: titleController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return tr(
                                                      "enter_valid_title");
                                                } else {
                                                  return null;
                                                }
                                              },
                                              maxLines: 1,
                                              decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.only(
                                                              bottom: 14,
                                                              left: 10),
                                                      border: InputBorder.none,),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, bottom: 8),
                                        child: RichText(
                                            text: TextSpan(
                                                text: tr("insert_tag"),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                                children: [
                                              TextSpan(
                                                text: tr("optional_choice"),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              TextSpan(
                                                text: tr("insert_tag_hint"),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ])),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                    bottomRight:
                                                        Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8))),
                                            child: SizedBox(
                                                height: 37,
                                                width: sizingInformation
                                                            .deviceScreenType ==
                                                        DeviceScreenType.mobile
                                                    ? 80
                                                    : 150,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: TextFormField(
                                                    onFieldSubmitted: (val) =>
                                                        addNewTag(),
                                                    controller: tagController,
                                                    maxLines: 1,
                                                    decoration:
                                                        const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 17,
                                                                    left: 10),
                                                            hintStyle: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            border: InputBorder
                                                                .none,
                                                            hintText: ""),
                                                  ),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: () => addNewTag(),
                                                child: const CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 255, 219, 59),
                                                    child: Icon(Icons.add)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: SizedBox(
                                            width: 350,
                                            height: 20,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: tags.length,
                                              itemBuilder: (context, index) =>
                                                  GestureDetector(
                                                      onTapDown:
                                                          _storeTagPosition,
                                                      onTap: () async =>
                                                          await _showTagPopupMenu(
                                                              context, index),
                                                      child: Tag(
                                                        text: tags[index],
                                                        background: const [
                                                          Color.fromARGB(255, 255, 255, 255),
                                                          Color.fromARGB(255, 255, 255, 255),
                                                          Color.fromARGB(255, 229, 229, 229)
                                                        ],
                                                        textColor: Colors.black,
                                                      )),
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              tr("insert_section"),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (_formKey.currentState!.validate()) {
                                                        addNewSection();                                                      
                                                    }
                                                  },
                                                  child: const CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              255, 219, 59),
                                                      child: Icon(Icons.add)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: SizedBox(
                                            width: 320,
                                            height: 140,
                                            child: Consumer<NewPostProvider>(
                                                builder: (context, provider, child) {
                                              return ListView.builder(
                                                itemCount:provider.sectionList.length,
                                                itemBuilder: (context, index) =>
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                  padding:
                                                          const EdgeInsets.only(
                                                              bottom: 4.0),
                                                  child: GestureDetector(
                                                        //  onTapDown:
                                                        //     _storeSectionPosition,
                                                        //  onLongPress: () async =>
                                                        //      await _showSectionPopupMenu(
                                                        //          context, index),
                                                        child: Section(
                                                        text: provider
                                                              .sectionList[index]
                                                              .title,
                                                          textColor: Colors.black,
                                                        ),
                                                  ),
                                                ),
                                                        GestureDetector(
                                                          onTapDown:  _storeSectionPosition,
                                                          onTap: () async =>
                                                              await _showSectionPopupMenu(context, index),
                                                          child: const Icon(Icons.menu, color: Colors.white,))
                                                      ],
                                                    ),
                                              );
                                            })),
                                      ),
                                   ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 30,)
                    ],
                  ),
                ))));
  }

  void showClosingMessage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: SizedBox(width: 300,
          child: Text(tr("attention_message_title"), 
           style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),),
        ),
           contentPadding: const EdgeInsets.only(top: 8, left: 12, right: 12),
           content: Padding(
             padding: const EdgeInsets.only(top:15.0),
             child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton (
                  onPressed: () {
                    AutoRouter.of(context).pop(false);
                  },
                  child: Text(tr("back")) ,
                ),
                 Padding(
                   padding: const EdgeInsets.only(bottom:18.0),
                   child: TextButton (
                    onPressed: () {
                        context.read<NewPostProvider>().clearPostProvider();
                        AutoRouter.of(context).pop(true);
                    },
                    child: Text(tr("exit_without_save"), style: const TextStyle(color: Colors.red),),
                ),
                 ),
              ],
             ),
           ),
           
      ) ,
      ).then((value) {
        if (value) {
          context.read<AuthProvider>().fetchUser();
          AutoRouter.of(context).pop();
        } 
      });
  }

  void showCretinoMessage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          tr("title_error_sezioni_vuote"),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 8, left: 12, right: 12),
        content: SizedBox(
            width: 120,
            height: 120,
            child: Center(
                child: Text(
              tr("isempty_error"),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 13),
            ))),
        actions: [
          MaterialButton(
            color: Colors.red,
            onPressed: () {
              AutoRouter.of(context).pop();
            },
            child: Text(
              tr("understood"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

 
  void addNewTag() {
    if (tagController.text.isNotEmpty) {
      setState(() {
        tags.add(tagController.text);
        tagController.text = "";
      });
    }
  }

  void addNewSection() {
    if (tempIndex > openedSectionIndex) {
      setState(() {
        openedSectionIndex = tempIndex;
      });
    }
    setState(() {
      openedSectionIndex++;
    });
    showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddSection(
              index: openedSectionIndex,
            )).then((value) => {
          if (value != null && !value)
            {
              setState(() {
                openedSectionIndex--;
              })
            }
        });
  }

  void _storeTagPosition(TapDownDetails details) {
    _tapTagPosition = details.globalPosition;
  }

  _showTagPopupMenu(BuildContext context, int index) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapTagPosition! & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem<int>(
            onTap: () {
              setState(() {
                tagController.text = tags[index];
                tags.remove(tags[index]);
              });
            },
            child: Text(tr("modify"))),
        PopupMenuItem<int>(
            onTap: () {
              setState(() {
                tags.remove(tags[index]);
              });
            },
            child: Text(tr("remove"))),
      ],
      elevation: 8.0,
    );
  }

  void _storeSectionPosition(TapDownDetails details) {
    _tapSectionPosition = details.globalPosition;
  }

  _showSectionPopupMenu(BuildContext context, int index) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu<int>(
      context: context,
      position: RelativeRect.fromRect(
          _tapSectionPosition! &
              const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem<int>(value: 1, child: Text(tr("modify"))),
        PopupMenuItem<int>(value: 2, child: Text(tr("remove"))),
        PopupMenuItem<int>(value: 3, child: Text(tr("move_up"))),
        PopupMenuItem<int>(value: 4, child: Text(tr("move_down"))),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value != null) {
        switch (value) {
          case 1:
            tempIndex = openedSectionIndex;
            openedSectionIndex = index;
            await context
                .read<NewPostProvider>()
                .setSectionForEdit(openedSectionIndex);
            await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => ResponsiveBuilder(
                    builder: (context, sizingInformation) => sizingInformation
                                .deviceScreenType ==
                            DeviceScreenType.desktop
                        ? EditSectionDesktop(
                            index: openedSectionIndex,
                          )
                        : sizingInformation.deviceScreenType ==
                                DeviceScreenType.tablet
                            ? EditSectionTablet(index: openedSectionIndex)
                            : EditSectionMobile(index: openedSectionIndex)));
            break;
          case 2:
            openedSectionIndex--;
            context.read<NewPostProvider>().removeSection(index);
            break;
          case 3:
            context.read<NewPostProvider>().moveUpSection(index);
            break;
          case 4:
            context.read<NewPostProvider>().moveDownSection(index);
            break;
        }
      }
    });
  }
}
