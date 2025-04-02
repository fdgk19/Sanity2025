import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/widgets/profile_widgets/edit_profile_alert.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:sanity_web/presentations/widgets/profile_widgets/list_connections_alert.dart';

import '../../../state_management/user_provider.dart';

class HeaderProfileMobile extends StatelessWidget {
  final UserModel currentUser;
  const HeaderProfileMobile({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    void showAlert(BuildContext context) {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => const EditProfileAlert());
    }

    void showFollower(BuildContext context, List<UserModel> userListFollower) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ListConnectionsAlert(
          userListFollowing: userListFollower,
          isFollowerView: true,
        ));
  }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 430,
          height: 260,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 243, 243),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.4,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 3) // changes position of shadow
                          ),
                    ],
                  ),
                  child: SizedBox(
                      width: 370,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:0.0, left: 10),
                            child: Stack(children: [
                              Container(
                                       decoration: BoxDecoration(
                                       color: Colors.blue,
                                      image: currentUser.photoUrl != null && currentUser.photoUrl!.isNotEmpty
                                      ? DecorationImage(image: NetworkImage(currentUser.photoUrl!))
                                      : const DecorationImage(
                                          image: AssetImage(
                                            "lib/resources/images/logosanity.png",
                                          ),
                                          fit: BoxFit.fitHeight),
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 248, 248, 248),
                                      ),
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(90))),
                                height: 100,
                                width: 100,
                              ),
                              Positioned(
                                  top: 80,
                                  left:2,
                                  child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () => showAlert(context),
                                        child: Container(
                                           width: 93,
                                        height: 20,
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Color.fromARGB(255, 254, 25, 25),
                                                Color.fromARGB(255, 111, 83, 224),
                                                Color.fromARGB(255, 50, 140, 162),
                                              ]),
                                              borderRadius:
                                                  BorderRadius.all(Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 5),
                                            child: Center(
                                              child: Text(
                                                tr("modify_profile"),
                                                style: GoogleFonts.lato(
                                                    color: Colors.white, fontSize: 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ))
                            ]),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, top: 14, right: 20),
                                child: SizedBox(
                                  width: 160,
                                  child: Tooltip(
                                    message: "${tr(currentUser.gender ?? tr("Dr"))} ${currentUser.name} ${currentUser.surname}",
                                    child: AutoSizeText("${tr(currentUser.gender ?? tr("Dr"))} ${currentUser.name} ${currentUser.surname}",
                                      minFontSize: 12,
                                      maxLines: 2,
                                      maxFontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                      style:const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, top: 5),
                                child:
                                currentUser.address!.isNotEmpty || currentUser.city!.isNotEmpty ?
                                 SizedBox(
                                  width: 180,
                                   child: Text(
                                   "${currentUser.address!}${currentUser.city!} ",
                                    style: const TextStyle(
                                       overflow: TextOverflow.ellipsis,
                                        fontSize: 13,
                                        color:  Color.fromARGB(
                                            255, 167, 167, 167),
                                        fontWeight: FontWeight.bold),
                                ),
                                 ) : const SizedBox(), 
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, top: 5),
                                child: SizedBox(
                                  width: 130,
                                  child: Text(
                                    currentUser.mainProfesion!,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                        fontSize: 13,
                                        color:  Color.fromARGB(
                                            255, 167, 167, 167),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: currentUser.isDoctor,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0.0, top: 5),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: (){
                                        if(currentUser.documents != null){
                                          var cvRef = currentUser.documents!.firstWhere((element) => element.contains("cv?"), orElse: () => "",);
                                          if(cvRef.isNotEmpty)
                                          {
                                            html.window.open(cvRef, "");
                                            //downloadFile(cvRef); 
                                          }
                                        }
                                      },
                                      child: Text(
                                          tr("cv"),
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: const Color.fromARGB(
                                                255, 167, 167, 167),
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: currentUser.isDoctor,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0.0, top: 5),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        if(currentUser.documents != null){
                                            var laureaRef = currentUser.documents!.firstWhere((element) => element.contains("degree?"), orElse: () => "",);
                                            if(laureaRef.isNotEmpty)
                                            {
                                              html.window.open(laureaRef, "");
                                              //downloadFile(laureaRef); 
                                            }
                                          }
                                      },
                                      child: Text(
                                          tr("degree"),
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: const Color.fromARGB(
                                                255, 167, 167, 167),
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right:5),
                            child: MouseRegion( cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                              onTap: () =>  showFollower(context, context.read<UserListProvider>().userListFollower ?? []),
                                child: Container(
                                  width: 50,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentUser.followers != null
                                            ? currentUser.followers!.length
                                                .toString()
                                            : "0",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        tr("followers"),
                                        style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.normal,
                                            color: Color.fromARGB(
                                                255, 219, 219, 219)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              ],
          ),
        ),
      ),
    );
  }

  void downloadFile(String url) {
    html.AnchorElement anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
}
