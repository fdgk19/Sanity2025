import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';

class EditProfileAlert extends StatefulWidget {
  const EditProfileAlert({super.key});

  @override
  State<EditProfileAlert> createState() => _EditProfileAlertState();
}

class _EditProfileAlertState extends State<EditProfileAlert> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> tags = [];
  TextEditingController tagController = TextEditingController();
  Offset? _tapTagPosition;
  bool? isCheckedMale = false;
  bool? isCheckedFemale = false;
  bool isDoctor = false;
  String? profileImage;

  @override
  void initState() {
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
      nameController.text = currentUser.name;
      surnameController.text = currentUser.surname;
      professionController.text = currentUser.mainProfesion ?? "";
      addressController.text = currentUser.address ?? "";
      cityController.text = currentUser.city ?? "";
      phoneController.text = currentUser.phoneNumber ?? "";
      descriptionController.text = currentUser.description ?? "";
      tags = currentUser.profession ?? [];
      isCheckedMale = currentUser.gender != null && currentUser.gender == "Dr.";
      isCheckedFemale = currentUser.gender != null && currentUser.gender == "Dr.ssa";
      isDoctor = currentUser.isDoctor;
      profileImage = currentUser.photoUrl;
      setState(() {});
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
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                constraints: const BoxConstraints(
                    maxHeight: 630,
                    maxWidth: 630,
                    minHeight: 70,
                    minWidth: 630),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: Center(
                            child: Text(
                              tr("modify_profile"),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1.4,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Center(
                          child: FittedBox(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      image: profileImage != null && profileImage!.isNotEmpty
                                      ? DecorationImage(image: NetworkImage(profileImage!), fit: BoxFit.cover)
                                      : const DecorationImage(
                                          image: AssetImage(
                                            "lib/resources/images/profile_placeholder.png",
                                          ),
                                          fit: BoxFit.fill),
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 248, 248, 248),
                                      ),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(70))),
                                  height: 130,
                                  width: 130,
                                ),
                                Positioned(
                                  top: 111,
                                  left: 13,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () async {
                                       var file = await uploadImage(context, sizingInformation.deviceScreenType,);

                                       if (file == null && mounted) {
                                            showerrortoast(tr("error_dimension"),context);
                                          }
                                        if(file != null && mounted){
                                          var imageRef = await context.read<AuthProvider>().uploadImage(file, "profile", InputCreateType.image);
                                          if(imageRef != null && mounted){
                                            await context.read<AuthProvider>().updateProfileImage(imageRef);
                                            setState(() {
                                              profileImage = imageRef;
                                            });
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 105,
                                        decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 56, 56, 56),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 8),
                                          child: Center(
                                            child: Text(
                                              tr("upload_image"),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: sizingInformation
                                                              .deviceScreenType ==
                                                          DeviceScreenType.mobile
                                                      ? 10
                                                      : 11),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 50,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr("enter_name"),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, bottom: 6),
                                      child: Container(
                                        width: 230,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                height: 37,
                                                width: 230,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0),
                                                  child: TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Il campo nome è vuoto';
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          nameController,
                                                      maxLines: 1,
                                                      decoration:
                                                          textInputDecoration),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr("enter_surname"),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0, bottom: 6),
                                      child: Container(
                                        width: 230,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                height: 37,
                                                width: 230,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Il campo cognome è vuoto';
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            surnameController,
                                                        maxLines: 1,
                                                        decoration:
                                                            textInputDecoration))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: isDoctor,
                              child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: 50,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                            Text(
                                                tr("enter_profession"),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                             Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0, bottom: 6),
                                                child: Container(
                                                  width: 230,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      8),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      8),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      8),
                                                              topRight:
                                                                  Radius.circular(
                                                                      8))),
                                                  child: SizedBox(
                                                      height: 37,
                                                      width: 230,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(0, 0, 0, 0),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value!.isEmpty) {
                                                              return 'Il campo professione è vuoto';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              professionController,
                                                          maxLines: 1,
                                                          decoration:
                                                              textInputDecoration,
                                                        ),
                                                      )),
                                                ),
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                        width: 230,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    "M",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Checkbox(
                                                    side: const BorderSide(
                                                        color: Colors.white,
                                                        width: 1.5),
                                                    value: isCheckedMale,
                                                    activeColor: Colors.green,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isCheckedMale = value;
                                                        isCheckedFemale = false;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                 const Text("F",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                  Checkbox(
                                                    side: const BorderSide(
                                                        color: Colors.white,
                                                        width: 1.5),
                                                    value: isCheckedFemale,
                                                    activeColor: Colors.green,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isCheckedFemale = value;
                                                        isCheckedMale = false;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ])),
                                  ]),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 50,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr("enter_city"),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 6),
                                            child: Container(
                                              width: 230,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                              child: SizedBox(
                                                  height: 37,
                                                  width: 230,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    child: TextFormField(
                                                      controller:
                                                          cityController,
                                                      maxLines: 1,
                                                      decoration:
                                                          textInputDecoration,
                                                    ),
                                                  )),
                                            ),
                                          )
                                       
                                  ],
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                              tr("enter_address"),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                      Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 6),
                                              child: Container(
                                                width: 230,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8),
                                                            topRight:
                                                                Radius.circular(
                                                                    8))),
                                                child: SizedBox(
                                                    height: 37,
                                                    width: 230,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: TextFormField(
                                                        controller:
                                                            addressController,
                                                        maxLines: 1,
                                                        decoration:
                                                            textInputDecoration,
                                                      ),
                                                    )),
                                              ),
                                            )
                                    ]),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                             Visibility(
                              visible: isDoctor,
                               child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: 50,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    tr("enter_skills"),
                                                     style: const TextStyle(
                                                         color: Colors.white),
                                                   ),
                                                    Padding(
                                                     padding: const EdgeInsets.only(
                                                          left: 8.0),
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
                                                ],
                                              ),
                                              Padding(
                                         padding: const EdgeInsets.only(top: 8.0),
                                           child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                               Container(
                                                height: 40,
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
                                                     height: 40,
                                                     width: 230,
                                                     child: Padding(
                                                       padding:
                                                           const EdgeInsets.fromLTRB(
                                                               0, 7, 0, 0),
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
                                             ],
                                           ),
                                         ),
                                        Padding(
                                         padding: const EdgeInsets.only(top: 12.0, left: 0),
                                         child: SizedBox(
                                             width: 230,
                                             height: 30,
                                             child: ListView.builder(
                                               scrollDirection: Axis.horizontal,
                                               itemCount: tags.length,
                                               itemBuilder: (context, index) =>
                                                   GestureDetector(
                                                       onTapDown:
                                                           _storeTagPosition,
                                                       onLongPress: () async =>
                                                           await _showTagPopupMenu(
                                                               context, index),
                                                       child: Tag(
                                                         text: tags[index],
                                                         background: const [
                                                           Color.fromARGB(
                                                               255, 0, 0, 0),
                                                           Color.fromARGB(
                                                               255, 32, 32, 32),
                                                           Color.fromARGB(
                                                               255, 75, 75, 75)
                                                         ],
                                                         textColor: Colors.white,
                                                       )),
                                             )),
                                       ),
                                    ],
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Text(
                                                  tr("enter_phone_number"),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                        Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0, bottom: 6),
                                                child: Container(
                                                  width: 230,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                      8),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      8),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      8),
                                                              topRight:
                                                                  Radius.circular(
                                                                      8))),
                                                  child: SizedBox(
                                                      height: 37,
                                                      width: 230,
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(0, 0, 0, 0),
                                                        child: TextFormField(
                                                          controller:
                                                              phoneController,
                                                          maxLines: 1,
                                                          decoration:
                                                              textInputDecoration,
                                                        ),
                                                      )),
                                                ),
                                              )
                                     
                                      ]),
                                ],
                                 ),
                             ),
                            const SizedBox(
                              height: 15,
                            ),        
                            Visibility(
                              visible: isDoctor,
                              child: Text(
                                tr("enter_description"),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isDoctor,
                              child: Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Container(
                                        width:
                                            sizingInformation.deviceScreenType ==
                                                    DeviceScreenType.desktop
                                                ? 510
                                                : 230,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                height: 200,
                                                width: sizingInformation
                                                            .deviceScreenType ==
                                                        DeviceScreenType.desktop
                                                    ? 510
                                                    : 230,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                  ),
                                                  child: TextFormField(
                                                    controller:
                                                        descriptionController,
                                                    maxLines:100,
                                                    decoration:
                                                        textInputDecoration,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, top: 30),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        var currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
                                        currentUser.name = nameController.text;
                                        currentUser.surname = surnameController.text;
                                        currentUser.mainProfesion = professionController.text;
                                        currentUser.address = addressController.text;
                                        currentUser.city = cityController.text;
                                        currentUser.description = descriptionController.text;
                                        currentUser.profession = tags;
                                        currentUser.gender = (isCheckedMale ?? false) ? "Dr." : (isCheckedFemale ?? false) ? "Dr.ssa" : "";
                                        currentUser.photoUrl = profileImage;
                                        currentUser.phoneNumber = phoneController.text;

                                        await context.read<AuthProvider>().updateCurrentUser(userUpdated: currentUser);
                                        
                                        if(mounted){
                                          AutoRouter.of(context).pop();
                                        }
                                      }
                                    },
                                    color: Colors.blue,
                                    height: 43,
                                    minWidth: 70,
                                    child: Text(
                                      tr("save"),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      AutoRouter.of(context).pop();
                                    },
                                    color: Colors.blue,
                                    height: 43,
                                    minWidth: 70,
                                    child: Text(
                                      tr("back"),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))));
  }

  void addNewTag() {
    if (tagController.text.isNotEmpty) {
      setState(() {
        tags.add(tagController.text);
        tagController.text = "";
      });
    }
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

 
}
