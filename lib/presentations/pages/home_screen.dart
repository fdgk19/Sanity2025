import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/presentations/pages/post_detail_screen.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/loader_new_professional_tile.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/loader_post_tile.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/new_professional_tile.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tile.dart';

import '../state_management/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController controller = ScrollController();
  bool isRaccomended = true;
  bool showloader = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<PostListProvider>().getRaccomendedPosts();
      if(mounted){
        await context.read<UserListProvider>().getRaccomendedUsers();
      }
    });
    
    super.initState();
  }

  void showAlertPost(PostModel post) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0))),
            contentPadding: const EdgeInsets.only(top: 0.0),
            content: PostDetailScreen(post: post)));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => SingleChildScrollView(
          child: Padding(
        padding: sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? const EdgeInsets.only(left: 30.0, right: 10)
            : const EdgeInsets.only(left: 30.0, right: 40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                sizingInformation.deviceScreenType == DeviceScreenType.mobile ||
                        sizingInformation.deviceScreenType ==
                            DeviceScreenType.tablet
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 22.0,
                    left: sizingInformation.deviceScreenType ==
                                DeviceScreenType.mobile ||
                            sizingInformation.deviceScreenType ==
                                DeviceScreenType.tablet
                        ? 0
                        : 20),
                child: Consumer<AuthProvider>(builder: (context, auth, _) {
                  return Row(
                    mainAxisAlignment: sizingInformation.deviceScreenType ==
                                DeviceScreenType.mobile ||
                            sizingInformation.deviceScreenType ==
                                DeviceScreenType.tablet
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.start,
                    children: [
                      Text("${tr("hi")} ${auth.currentUser.name}!",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            textStyle: Theme.of(context).textTheme.headlineMedium,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          )),
                    ],
                  );
                }),
              ),
              sizingInformation.deviceScreenType != DeviceScreenType.mobile
                  ? const SizedBox.shrink()
                  : Padding(
                      padding:
                          const EdgeInsets.only(top: 14.0, left: 0, right: 20),
                      child: SizedBox(
                        height: 113,
                        child: Consumer<UserListProvider>(
                            builder: (context, value, child) {
                          if (value.loading) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Color.fromARGB(255, 234, 234, 234),
                                    ),
                                    Container(width: 40, height: 14, decoration: const BoxDecoration(color: Color.fromARGB(255, 234, 234, 234), borderRadius: BorderRadius.all(Radius.circular(4))),),
                                    Container(width: 30, height: 14, decoration: const BoxDecoration(color: Color.fromARGB(255, 234, 234, 234), borderRadius: BorderRadius.all(Radius.circular(4))),)
                            
                                  ],
                                ),
                              ),
                            );
                          } else if (value.userListPro == null ||
                              value.userListPro!.isEmpty) {
                            return Center(
                              child: Text(tr("no_pro_list")),
                            );
                          } else {
                            return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: value.userListPro!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => AutoRouter.of(context)
                                          .push(ProfileDetailRoute( uid: value.userListPro![index].uid)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                             Container(
                                                width: 75,
                                                height: 75,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                    image:value.userListPro![index].photoUrl != null && value.userListPro![index].photoUrl!.isNotEmpty
                                                    ? DecorationImage(
                                                      image: NetworkImage(value.userListPro![index].photoUrl!), fit: BoxFit.cover,)
                                                    : const DecorationImage(image: AssetImage(
                                                              "lib/resources/images/logosanity.png"),
                                                              fit: BoxFit.cover,),
                                                    borderRadius: const BorderRadius.all( Radius.circular(50)),
                                                    //borderRadius: BorderRadius.circular(12)
                                                    ),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical:2.0),
                                              child: SizedBox(
                                                width: 75,
                                                child: Text(
                                                  "${tr(value.userListPro![index].gender ??tr ("Dr."))} ${value.userListPro![index].name} ${value.userListPro![index].surname}",
                                                  style: const TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis),
                                                ),
                                              ),
                                            ),
                                             SizedBox(
                                               width: 70,
                                               child: Text(
                                                "${value.userListPro![index].mainProfesion}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 13,overflow: TextOverflow.ellipsis),
                                            ),
                                             ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                          }
                        }),
                      ),
                    ),
              Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      left: sizingInformation.deviceScreenType ==
                                  DeviceScreenType.mobile ||
                              sizingInformation.deviceScreenType ==
                                  DeviceScreenType.tablet
                          ? 0
                          : 20),
                  child: Row(
                      mainAxisAlignment: sizingInformation.deviceScreenType ==
                                  DeviceScreenType.mobile ||
                              sizingInformation.deviceScreenType ==
                                  DeviceScreenType.tablet
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                            minWidth: 120,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            color: isRaccomended ? const Color.fromARGB(255, 240, 240, 240) :Colors.white,
                            child: Text(
                              tr("racommended"),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 13),
                            ),
                            onPressed: () async {
                              await context.read<PostListProvider>().getRaccomendedPosts();
                              setState(() {
                                isRaccomended = true;
                              });
                            }),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: MaterialButton(
                              minWidth: 120,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                            color: !isRaccomended ? const Color.fromARGB(255, 240, 240, 240) :Colors.white,
                              child: Text(
                                tr("followed"),
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 13),
                              ),
                              onPressed: () async {
                                await context
                                    .read<PostListProvider>()
                                    .getFollowingPosts();
                                setState(() {
                                  isRaccomended = false;
                                });
                              }),
                        ),
                      ])),
              Padding(
                padding: sizingInformation.deviceScreenType ==
                        DeviceScreenType.mobile
                    ? const EdgeInsets.only(top: 20.0, left: 0)
                    : const EdgeInsets.only(top: 20.0, left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Consumer<PostListProvider>(
                      builder: (context, value, child) {
                        if (value.loading) {
                             return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: sizingInformation
                                                      .deviceScreenType ==
                                                  DeviceScreenType.mobile
                                              ? 1
                                              : sizingInformation
                                                          .deviceScreenType ==
                                                          DeviceScreenType.tablet
                                                      ? (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2) ~/
                                                          220
                                                      : (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2) ~/
                                                          220, //se non va bene torna a 180
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: 8,
                                      itemBuilder: (BuildContext ctx, index) =>
                                             const Padding(
                                                  padding:
                                                       EdgeInsets.only(right: 25),
                                                  child: LoadingPostTile(
                                                  ))
                                            
                                              );
                        } else if (isRaccomended &&
                            (value.postListPro == null ||
                                value.postListPro!.isEmpty)) {
                          return SizedBox(
                              width: 600,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: Text(tr("no_pro_post_list")),
                              ));
                        } else if (!isRaccomended &&
                            (value.postListFollowed == null ||
                                value.postListFollowed!.isEmpty)) {
                          return SizedBox(
                              width: 600,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: Text(tr("no_followed_post_list")),
                              ));
                        } else {
                          return  GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: sizingInformation
                                                      .deviceScreenType ==
                                                  DeviceScreenType.mobile
                                              ? 1
                                              : sizingInformation
                                                          .deviceScreenType ==
                                                      DeviceScreenType.tablet
                                                  ? (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) ~/
                                                      220
                                                  : (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) ~/
                                                      220, //se non va bene torna a 180
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: isRaccomended
                                      ? value.postListPro!.length
                                      : value.postListFollowed!.length,
                                  itemBuilder: (BuildContext ctx, index) =>
                                      isRaccomended
                                          ? Padding(
                                              padding:
                                                 EdgeInsets.only(right: 25, bottom: sizingInformation
                                                      .deviceScreenType ==
                                                  DeviceScreenType.mobile ||sizingInformation
                                                          .deviceScreenType ==
                                                      DeviceScreenType.tablet ? 30: 0),
                                              child: MouseRegion(cursor: SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () => showAlertPost(
                                                      value.postListPro![index]),
                                                  child: PostTile(
                                                      post:
                                                          value.postListPro![index]),
                                                ),
                                              ))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 25),
                                              child: MouseRegion(cursor: SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () => showAlertPost(
                                                      value.postListFollowed![index]),
                                                  child: PostTile(
                                                      post: value
                                                          .postListFollowed![index]),
                                                ),
                                              )));
                        }
                      },
                    )),
                    sizingInformation.deviceScreenType ==
                            DeviceScreenType.mobile
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    tr("new_doctors"),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 580,
                                  width: 225,
                                  child: Consumer<UserListProvider>(
                                      builder: (context, value, child) {
                                    if (value.loading) {
                                      return const LoaderNewProfessionalTile();
                                    } else if (value.userListPro == null ||
                                        value.userListPro!.isEmpty) {
                                      return Center(
                                        child: Text(tr("no_pro_list")),
                                      );
                                    } else {
                                      return ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: value.userListPro!
                                                .length, //this value can be at most 4
                                            itemBuilder: (context, index) {
                                              return MouseRegion(cursor: SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () => AutoRouter.of(context).push(ProfileDetailRoute(uid: value.userListPro![index].uid)),
                                                  child: NewProfessionalTile(
                                                      user: value.userListPro![index]),
                                                ),
                                              );
                                            },
                                          );
                                    }
                                  }),
                                )
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ]),
      )),
    );
  }
}
