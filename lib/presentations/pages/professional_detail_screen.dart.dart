import 'package:easy_localization/easy_localization.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
import 'package:sanity_web/presentations/widgets/profile_widgets/saved_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/widgets/profile_widgets/mobile_view/header_prof_detail_mobile.dart';
import 'package:sanity_web/presentations/widgets/profile_widgets/desktop_view/header_prof_detail_desktop.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key, @PathParam('uid') required this.uid});
  final String uid;


  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  int numlines = 3;
  @override
  void initState() { 
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserListProvider>().getUserDetail(userId: widget.uid);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 254, 25, 25),
                Color.fromARGB(255, 111, 83, 224),
                Color.fromARGB(255, 50, 140, 162),
                Color.fromARGB(255, 20, 182, 100)
              ])),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Row(
                  children: [
                         MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => AutoRouter.of(context).push(const MainRoute()),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 5, left: 20.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => AutoRouter.of(context).push(const MainRoute()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                              "lib/resources/images/logosanity.png"),
                        ),
                      ),
                    ),
                  
                  ],
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: Consumer2<UserListProvider, AuthProvider>(
            builder: (context, userProvider, authProvider, child) {
              if(userProvider.loading){
                 return Center(
                    child: LoadingAnimationWidget.beat(
                  color: const Color.fromARGB(255, 255, 177, 59),
                  size: 60,
                ));
              } else if(userProvider.userDetail == null){
                return const SizedBox.shrink();
              } else {
                return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: Stack(children: [
                      userProvider.userDetail!.photoCoverUrl != null &&  userProvider.userDetail!.photoCoverUrl!.isNotEmpty
                     ? SizedBox(
                       height: 160,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(userProvider.userDetail!.photoCoverUrl!, fit: BoxFit.cover,),)
                     : Container(
                        height: 160,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 254, 25, 25),
                          Color.fromARGB(255, 111, 83, 224),
                          Color.fromARGB(255, 50, 140, 162),
                          Color.fromARGB(255, 20, 182, 100),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: sizingInformation.deviceScreenType ==
                                    DeviceScreenType.tablet ||
                                sizingInformation.deviceScreenType ==
                                    DeviceScreenType.mobile
                            ? HeaderProfDetailMobile(
                                user: userProvider.userDetail!, 
                                isFollowedByMe: authProvider.currentUser.following == null || authProvider.currentUser.following!.isEmpty 
                                  ? false
                                  : authProvider.currentUser.following!.any((f) => f == userProvider.userDetail!.uid)
                              )
                            : HeaderProfDetailDesktop(
                                user: userProvider.userDetail!,
                                isFollowedByMe: authProvider.currentUser.following == null || authProvider.currentUser.following!.isEmpty 
                                  ? false
                                  : authProvider.currentUser.following!.any((f) => f == userProvider.userDetail!.uid)
                              ),
                      ),
                  
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 18),
                    width: 480,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:10,top: 13),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 198, 244, 242),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0.4,
                                          blurRadius: 3,
                                          offset: const Offset(
                                              0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                                      child: DefaultTextStyle(
                                        style: const TextStyle(fontSize: 13),
                                        child: DefaultTextStyle(
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontFamily: "PublicSansBlack",
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                          child: Text(
                                            tr("description"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10, right:10,top: 10),
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 500,
                                maxWidth: 500,
                                minHeight: 100
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.4,
                                    blurRadius: 3,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: const Color.fromARGB(255, 198, 244, 242),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReadMoreText(
                                  userProvider.userDetail!.description!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10,top: 10),
                            child: SizedBox(
                              height: 30,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: userProvider.userDetail!.profession?.length ?? 0 ,
                                itemBuilder: (context, index) {
                                return  MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:3.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 245, 165, 212),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(9),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0.4,
                                              blurRadius: 3,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child:  Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: DefaultTextStyle(
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontFamily: "PublicSansBlack",
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal),
                                            child: Text(
                                              userProvider.userDetail!.profession![index]
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              );
                       
                              },),
                            ),
                          ),
                        ]),
                  ),
                    SizedBox(
                     width: 750,
                     child: SavedBody(doctorId:  userProvider.userDetail!.uid,)),
                ],
              );
              }
            }
          ),
        ),
      ),
    );
  }
}
