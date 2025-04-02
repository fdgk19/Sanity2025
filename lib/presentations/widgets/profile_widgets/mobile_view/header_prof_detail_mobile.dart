import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/notification_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class HeaderProfDetailMobile extends StatefulWidget {
  const HeaderProfDetailMobile({super.key, required this.user, required this.isFollowedByMe});
  final UserModel user;
  final bool isFollowedByMe;

  @override
  State<HeaderProfDetailMobile> createState() => _HeaderProfDetailMobileState();
}

class _HeaderProfDetailMobileState extends State<HeaderProfDetailMobile> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<UserListProvider>().getUserPostCount(userId: widget.user.uid);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 400,
        height: 254,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 254,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 248, 248, 248),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.4,
                        blurRadius: 3,
                        offset: const Offset(0, 3) // changes position of shadow
                        ),
                  ],
                ),
                child: SizedBox(
                    width: 500,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 130.0, top: 12, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //todo get from models
                             Row(
                                children: [
                                  DefaultTextStyle(
                                    style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 200
                                      ),
                                      child: Tooltip(
                                        message: "${tr(widget.user.gender ?? tr("Dr"))} ${widget.user.name} ${widget.user.surname}",
                                        child: AutoSizeText(
                                        "${tr(widget.user.gender ?? tr("Dr"))} ${widget.user.name} ${widget.user.surname}",
                                        maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.user.isPremium
                                  ?  const SizedBox(
                                    child: Column(
                                      children:[
                                         Icon(Icons.verified, color: Colors.blue, size: 13,),
                                      ],
                                    ))
                                  : const SizedBox.shrink(),
                                ],
                              ),
                                 ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0, top: 0),
                        child: Row(
                          children: [
                             //todo get from models
                            DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color:
                                       const Color.fromARGB(255, 167, 167, 167),
                                  fontWeight: FontWeight.bold),
                              child:  Text(
                                widget.user.mainProfesion!
                              ),
                            ),
                           
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0, top: 0),
                        child: Row(
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 220,
                                minWidth: 110
                              ),
                              child: DefaultTextStyle(
                               style: GoogleFonts.lato(
                                   fontSize: 13,
                                   color:const Color.fromARGB(255, 0, 0, 0),
                                   fontWeight: FontWeight.bold),
                               child:  Text(
                                 "${widget.user.address!} ${widget.user.city!} ",
                                 maxLines: 1,
                               ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0, top: 0),
                        child: Row(
                          children: [
                             DefaultTextStyle(
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold),
                              child:  Text(
                                  widget.user.phoneNumber != null
                                 ? "${widget.user.phoneNumber}"
                                 : ""
                              ),
                            ),
                          ],),
                      ),
                      widget.user.isDoctor && widget.user.documents != null ?
                               Row(
                                 children: [
                                   Padding(
                                      padding: const EdgeInsets.only(top: 0, left: 130),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: (){
                                            if(widget.user.documents != null){
                                              var cvRef = widget.user.documents!.firstWhere((element) => element.contains("cv?"), orElse: () => "",);
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
                                 ],
                               ): const SizedBox(height: 18,),
                                widget.user.isDoctor && widget.user.documents != null ?
                                 Row(
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(top: 0, left: 130),
                                       child: MouseRegion(
                                         cursor: SystemMouseCursors.click,
                                         child: GestureDetector(
                                           onTap: (){
                                             if(widget.user.documents != null){
                                               var laureaRef = widget.user.documents!.firstWhere((element) => element.contains("degree?"), orElse: () => "",);
                                               if(laureaRef.isNotEmpty)
                                               {
                                                 html.window.open(laureaRef, "");
                                                 //downloadFile(cvRef); 
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
                                   ],
                                 ) :const SizedBox(height: 18,),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                        child: Container(
                          height: 70,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<UserListProvider>(
                                  builder: (context, value, child) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //todo get from models
                                         DefaultTextStyle(
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: "PublicSansBlack",
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          child: Text(
                                             value.userPostCount.toString()

                                          ),
                                        ),
                                        DefaultTextStyle(
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 197, 197, 197),
                                              fontFamily: "PublicSansBlack",
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                          child: Text(
                                            tr("programs"),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:  [
                                    DefaultTextStyle(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "PublicSansBlack",
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                      child: Text(
                                          widget.user.followers != null ? widget.user.followers!.length.toString() : "0",
                                      ),
                                    ),
                                     DefaultTextStyle(
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 197, 197, 197),
                                          fontFamily: "PublicSansBlack",
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal),
                                      child: Text(
                                       tr("connections"),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:  [
                                    DefaultTextStyle(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "PublicSansBlack",
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                      child: Text(
                                            widget.user.following != null ? widget.user.following!.length.toString() : "0",
                                      ),
                                    ),
                                      DefaultTextStyle(
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 197, 197, 197),
                                          fontFamily: "PublicSansBlack",
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal),
                                      child: Text(
                                       tr("followed"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: () async{
                                            if(widget.isFollowedByMe){
                                              await context.read<AuthProvider>().removeFollow(widget.user.uid);
                                            }else{
                                              await context.read<AuthProvider>().addFollow(widget.user.uid);
                                              if(mounted){
                                                var current = context.read<AuthProvider>().currentUser;
                                                await context.read<NotificationProvider>().sendNotification(
                                                  toUserId: widget.user.uid, 
                                                  fromUserId: current.uid, 
                                                  fromFullName: "${current.name} ${current.surname}", 
                                                  fromImage: current.photoUrl ?? "", 
                                                  isDoctorPremium: widget.user.isDoctor && widget.user.isPremium,
                                                  body: "ha iniziato a seguirti"
                                                );
                                              }
                                            }
                                          },
                                          child: 
                                           
                                          Consumer<AuthProvider>(
                                            builder: (context, value, child) {
                                               return value.currentUser.uid != widget.user.uid  
                                               ? Container(
                                                decoration:  BoxDecoration(
                                                    color: widget.isFollowedByMe 
                                                      ? Colors.red
                                                      :const Color.fromARGB(255, 75, 207, 255),
                                                    borderRadius: const BorderRadius.all(
                                                        Radius.circular(7))),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                       const  EdgeInsets.fromLTRB(7, 5, 7, 5),
                                                    child: DefaultTextStyle(
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 12),
                                                      child: Text(
                                                        widget.isFollowedByMe 
                                                        ? tr("no_follow_doctor")
                                                        : tr("follow_doctor"),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              : const SizedBox.shrink(); 
                                            }
                                          )),
                                    ),
                          ],
                        ),
                      )
                         
                    ])),
              ),
            ),
            Positioned(
              left: 20,
              top: 30,
              child: SizedBox(
                height: 160,
                child: Stack(children: [
                  Container(
               decoration: BoxDecoration(
                        image:  widget.user.photoUrl != null && widget.user.photoUrl!.isNotEmpty 
                        ? DecorationImage(image:  NetworkImage(widget.user.photoUrl!),  fit: BoxFit.cover)
                        : const DecorationImage(image: AssetImage("lib/resources/images/logosanity.png"), ),
                        color: Colors.blue,
                        border: Border.all(
                          color: const Color.fromARGB(255, 248, 248, 248),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(70))),
                    height: 90,
                    width: 90,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
