import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/create_sections.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/desktop_view/edit_section_desktop.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/mobile_view/edit_section_mobile.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/tablet_view/edit_section_tablet.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/post_section.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/generate_code_alert.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/search_item.dart';

import '../../state_management/user_provider.dart';

class CreatePostAlert extends StatefulWidget {
  const CreatePostAlert({super.key});

  @override
  State<CreatePostAlert> createState() => _CreatePostAlertState();
}

class _CreatePostAlertState extends State<CreatePostAlert> {
  final _formKey = GlobalKey<FormState>();

  int openedSectionIndex = -1;

  int tagCount = 1;
  int sectionCount = 1;
  int tempIndex = -1;

  TextEditingController tagController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  Offset? _tapTagPosition;
  Offset? _tapSectionPosition;

  TextEditingController searchController = TextEditingController();
  List<UserModel> searchResult = [];


  Color color = Colors.black.withOpacity(0.0);
  Color textColor = Colors.white.withOpacity(0.0);

  PlatformFile? imageUploaded;
  bool isUploaded = false;

  List<String> tags = [];

  @override
  void initState() {
    _tapTagPosition = const Offset(0, 0);
    _tapSectionPosition = const Offset(0, 0);
    rootBundle.load('lib/resources/images/sanityplaceholder.png').then((data) {
      var dataUint = data.buffer.asUint8List();
      setState(() {
        imageUploaded = PlatformFile(
            name: "sanityplaceholder.png", size: dataUint.length, bytes: dataUint);
      });
    });
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
                                           showPubblishMessage();
                                          }
                                        },
                                        child: AutoSizeText(
                                          tr("pubblish"),
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
                                          !isUploaded
                                              ? Container(
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
                                                  decoration:
                                                      const BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                              "lib/resources/images/imagenull.png",
                                                            ),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tr("insert_image"),
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize: sizingInformation
                                                                        .deviceScreenType ==
                                                                    DeviceScreenType
                                                                        .mobile
                                                                ? 13
                                                                : 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      MouseRegion(
                                                        cursor:
                                                            SystemMouseCursors
                                                                .click,
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              //var file = await fileFromStorage(imageExtSupported);
                                                              var file = await uploadImage(context, sizingInformation.deviceScreenType,);
                                                              
                                                               if (file == null && mounted) {
                                                                showerrortoast(tr("error_dimension"),context);
                                                              }
                                                              setState(() {
                                                                isUploaded =  true;
                                                                imageUploaded = file;
                                                              }
                                                              );
                                                           
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CircleAvatar(
                                                                      backgroundColor: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          199,
                                                                          59),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            30,
                                                                      )),
                                                            )),
                                                      )
                                                    ],
                                                  ))
                                              : MouseRegion(
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
                                                      if (file != null) {
                                                        setState(() {
                                                          isUploaded = true;
                                                          imageUploaded = file;
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
                                                                      child: Image.memory(
                                                                        imageUploaded!
                                                                            .bytes!,
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
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      if (context
                                                              .read<
                                                                  NewPostProvider>()
                                                              .sectionList
                                                              .isEmpty &&
                                                          context
                                                                  .read<
                                                                      NewPostProvider>()
                                                                  .post ==
                                                              null) {
                                                        showMessage();
                                                      } else {
                                                        addNewSection();
                                                      }
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
                                                builder:
                                                    (context, provider, child) {
                                              return ListView.builder(
                                                itemCount:
                                                    provider.sectionList.length,
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
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    
                    ],
                  ),
                ))));
  }

  void showPubblishMessage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: SizedBox(width: 300,
          child: Text(tr("pubblish_message"), 
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
                    AutoRouter.of(context).pop("back");
                  },
                  child: Text(tr("back")) ,
                ),
                 TextButton (
                  onPressed: () {
                      AutoRouter.of(context).pop("generatedcode");
                  },
                  child: Text(tr("generate_code"), style: const TextStyle(color: Colors.blue),),
                ),
                 TextButton (
                  onPressed: () {
                      AutoRouter.of(context).pop("private");
                  },
                  child: Text(tr("pubblish_private"), style: const TextStyle(color: Colors.blue),),
                ),
                 Padding(
                   padding: const EdgeInsets.only(bottom:20.0),
                   child: TextButton (
                    onPressed: () {
                      //chiamata a save draft
                       AutoRouter.of(context).pop("pubblic");
                    },
                    child: Text(tr("pubblish_pubblic"), style: const TextStyle(color: Colors.blue),) ,
                ),
                 )
              ],
             ),
           ),
      ) ,
      ).then((value) async {
        if (value == "private")  {
          var result = await showSearchUser();
          if(result != null && mounted) {
            await context.read<NewPostProvider>().publishPost(isPrivate: true, destinationUserId: result, imageUploaded: imageUploaded);
            if(mounted){
              context.read<AuthProvider>().fetchUser();
              AutoRouter.of(context).pop();
            }
          }
        } else if (value == "pubblic") {
          await context.read<NewPostProvider>().publishPost(isPrivate: false, imageUploaded: imageUploaded );
          if(mounted){
              context.read<AuthProvider>().fetchUser();
              AutoRouter.of(context).pop();
            }
        }else if (value == "generatedcode"){
          var code = await showGeneratedCodeAlert();
          if (code != null && mounted) {
            await context.read<NewPostProvider>().publishPostWithCode(imageUploaded: imageUploaded, reedemableCode: code);
             if(mounted){
              context.read<AuthProvider>().fetchUser();
              AutoRouter.of(context).pop();
            }
          }          
        }      
      });
  }

  Future<String?> showGeneratedCodeAlert() async {
    return await showDialog<String?>(
      context: context,
      builder: (context) => const  AlertDialog(
        content: GenerateCodeAlert(),
      ), );
  }

 Future<String?> showSearchUser() async {
    return await showDialog<String>(
     context: context,
     builder: (context) => AlertDialog(
      content: SizedBox(
        width: 700,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            Padding(padding: const EdgeInsets.all(2.0), 
            child: Text(tr("choose_user_text"), 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextField(
                onSubmitted: (value) {
                  context.read<UserListProvider>().searchAllUser();
                },
                cursorColor: Colors.black,
                style: const TextStyle(fontSize: 18),
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: IconButton(
                            onPressed: () => {},
                            icon: const Icon(
                              Icons.search,
                              size: 30,
                            ))),
                    border: InputBorder.none,
                    hintText: "Cerca..."),
                       ),
                    ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 450,
              child: Consumer<UserListProvider>(
                        builder: (context, value, child) {
                      searchResult.clear();
                      if (value.loading) {
                      return Center(
                          child: LoadingAnimationWidget.beat(
                        color: const Color.fromARGB(255, 255, 177, 59),
                        size: 60,
                      ));
                      } else {
                        if (value.userSearched != null) {
                          for (var element in value.userSearched!) {
                            if (searchController.text.isNotEmpty) {
                              if (element.name.toLowerCase().contains(
                                      searchController.text.toLowerCase()) ||
                                  element.surname.toLowerCase().contains(
                                      searchController.text.toLowerCase())
                                ) {
                                searchResult.add(element);
                              }
                            }
                          }
                        }
                        if (searchResult.isEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: searchResult.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => AutoRouter.of(context).pop(searchResult[index].uid)  ,
                                      child: SearchItem(
                                          name: searchResult[index].name,
                                          image: searchResult[index].photoUrl,
                                          isPro: searchResult[index].isPremium,
                                          mainProfession: searchResult[index].mainProfesion ?? "",
                                          surname: searchResult[index].surname),
                                    ),
                                  ),
                                );
                              });
                        }
                      }
                    }),
           
              )

                 ],
        ),
      ),
     ) 
    );
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
                 TextButton (
                  onPressed: () {
                      context.read<NewPostProvider>().deletePost();
                      AutoRouter.of(context).pop(true);
                  },
                  child: Text(tr("exit_without_save"), style: const TextStyle(color: Colors.red),),
                ),
                 Padding(
                   padding: const EdgeInsets.only(bottom:20.0),
                   child: TextButton (
                    onPressed: () {
                       context.read<NewPostProvider>().saveAndExit(title: titleController.text, imageUploaded: imageUploaded, tags: tags);
                       AutoRouter.of(context).pop(true);
                    },
                    child: Text(tr("save_and_exit"), style: const TextStyle(color: Colors.blue),) ,
                ),
                 )
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

 
  void showMessage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          tr("create_post_advice_title"),
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
              tr("create_post_advice_body"),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 13),
            ))),
        actions: [
          MaterialButton(
            color: Colors.red,
            onPressed: () {
              AutoRouter.of(context).pop(false);
            },
            child: Text(
              tr("back"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              AutoRouter.of(context).pop(true);
            },
            child: Text(
              tr("continue"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ).then((valueFromDialog) async {
      if (valueFromDialog) {
        var createResult = await context
            .read<NewPostProvider>()
            .createDraftPost(
                title: titleController.text,
                mainImage: imageUploaded!,
                tags: tags);

        if (createResult) {
          addNewSection();
        }
      }
    });
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
