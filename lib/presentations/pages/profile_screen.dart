// ignore_for_file: avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/pages/post_detail_screen.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/loader_new_professional_tile.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/loader_post_tile.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/new_professional_tile.dart';
import 'package:sanity_web/presentations/widgets/profile_widgets/desktop_view/header_profile_desktop.dart';
import 'package:sanity_web/presentations/widgets/profile_widgets/mobile_view/header_profile_mobile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sanity_web/presentations/widgets/profile_widgets/list_connections_alert.dart';

import '../widgets/other_widgets/post_tile.dart';
import '../widgets/other_widgets/post_tile_created_by_me.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentPage = 1;
  double containerOpacitythree = 0;
  double containerOpacitytwo = 0;
  double containerOpacityone = 0;
  double textOpacity = 0;
  PlatformFile? imageUploaded;
  Color color = Colors.black.withOpacity(0.0);
  Color textColor = Colors.white.withOpacity(0.0);

  void showFollowing(BuildContext context, List<UserModel> userListFollowing) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => ListConnectionsAlert(
          userListFollowing: userListFollowing, 
          isFollowerView: false,
        ));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<PostListProvider>().getSavedPosts();
      if(mounted){
        await context.read<UserListProvider>().getFollowingUsers();
      }
      if(mounted){
        await context.read<UserListProvider>().getFollowersUsers();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthProvider>(context).currentUser;
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Stack(children: [
                Stack(
                  children: [
                    user.photoCoverUrl == null || user.photoCoverUrl!.isEmpty 
                    ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 254, 25, 25),
                          Color.fromARGB(255, 111, 83, 224),
                          Color.fromARGB(255, 50, 140, 162),
                          Color.fromARGB(255, 20, 182, 100)
                        ]))),
                      ),
                    )
                    : Container(
                      width:
                          MediaQuery.of(context).size.width,
                      height: 170,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                              child: Image.network(
                                user.photoCoverUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          containerOpacityone = 0.1;
                          containerOpacitytwo = 0.3;
                          containerOpacitythree = 0.5;
                          textOpacity = 1;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          containerOpacityone = 0;
                          containerOpacitytwo = 0;
                          containerOpacitythree = 0;
                          textOpacity = 0;
                        });
                      },

                      child: MouseRegion(cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                            onTap: () async {
                              var file = await uploadImage(context, sizingInformation.deviceScreenType,);
                               if (file == null && mounted) {
                                  showerrortoast(tr("error_dimension"),context);
                                }
                              if(file != null && mounted){
                                var coverRef = await context.read<AuthProvider>().uploadImage(file, "cover", InputCreateType.image);
                                if(coverRef != null && mounted){
                                  await context.read<AuthProvider>().updateCoverImage(coverRef);
                                }

                              }
                            },
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                      Colors.white.withOpacity(0),
                                      Colors.black
                                          .withOpacity(containerOpacityone),
                                      Colors.black
                                          .withOpacity(containerOpacitytwo),
                                      Colors.black
                                          .withOpacity(containerOpacitythree)
                                    ])),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: sizingInformation
                                                      .deviceScreenType ==
                                                  DeviceScreenType.tablet ||
                                              sizingInformation
                                                      .deviceScreenType ==
                                                  DeviceScreenType.mobile
                                          ? const EdgeInsets.only(
                                              top: 20,
                                              left: 20,
                                              right: 20,
                                              bottom: 90)
                                          : const EdgeInsets.all(20),
                                      child: Text(
                                        tr("edit_image"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: sizingInformation
                                                            .deviceScreenType ==
                                                        DeviceScreenType
                                                            .tablet ||
                                                    sizingInformation
                                                            .deviceScreenType ==
                                                        DeviceScreenType
                                                            .mobile
                                                ? 16
                                                : 21,
                                            color: Colors.white
                                                .withOpacity(textOpacity)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ),
                      ),
                    )
                  ],
                ),
                sizingInformation.deviceScreenType == DeviceScreenType.tablet ||
                        sizingInformation.deviceScreenType ==
                            DeviceScreenType.mobile
                    ? HeaderProfileMobile(currentUser: user)
                    : HeaderProfileDesktop(currentUser: user)
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 35,
                width: 350,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: MaterialButton(
                          minWidth: 120,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          color: currentPage == 1
                              ? const Color.fromARGB(255, 240, 240, 240)
                              : Colors.white,
                          child: Text(
                            tr("saved"),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 13),
                          ),
                          onPressed: () async {
                            await context
                                .read<PostListProvider>()
                                .getSavedPosts();
                            setState(() {
                              currentPage = 1;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: MaterialButton(
                          minWidth: 120,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          color: currentPage == 2
                              ? const Color.fromARGB(255, 240, 240, 240)
                              : Colors.white,
                          child: Text(
                            tr("received"),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 13),
                          ),
                          onPressed: () async {
                            await context
                                .read<PostListProvider>()
                                .getPostsForMe();
                            setState(() {
                              currentPage = 2;
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: user.isDoctor,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: MaterialButton(
                            minWidth: 120,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            color: currentPage == 3
                                ? const Color.fromARGB(255, 240, 240, 240)
                                : Colors.white,
                            child: Text(
                              tr("created_by_me"),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 13),
                            ),
                            onPressed: () async {
                              await context
                                  .read<PostListProvider>()
                                  .getPostsByMe();
                              setState(() {
                                currentPage = 3;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    sizingInformation.deviceScreenType ==
                            DeviceScreenType.mobile
                        ? SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: MaterialButton(
                                  minWidth: 120,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  color: currentPage == 4
                                      ? const Color.fromARGB(255, 240, 240, 240)
                                      : Colors.white,
                                  child: Text(
                                    tr("followed"),
                                    style: const TextStyle(
                                        color: Colors.blue, fontSize: 11),
                                  ),
                                  onPressed: () => setState(() {
                                        currentPage = 4;
                                      })),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 25),
              child: Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: currentPage == 1
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Consumer<PostListProvider>(
                                  builder: (context, value, child) {
                                if (value.loading) {
                                  return GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: sizingInformation
                                                          .deviceScreenType ==
                                                      DeviceScreenType.mobile
                                                  ? 1
                                                  : sizingInformation
                                                              .deviceScreenType ==
                                                          DeviceScreenType
                                                              .tablet
                                                      ? (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2) ~/
                                                          220
                                                      : (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2) ~/
                                                          180,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: 8,
                                      itemBuilder: (BuildContext ctx, index) =>
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 25),
                                              child: LoadingPostTile()));
                                } else if (value.postListSaved == null ||
                                    value.postListSaved!.isEmpty) {
                                  return SizedBox(
                                      width: 600,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Center(
                                        child: Text(tr("no_saved_list")),
                                      ));
                                } else {
                                  return GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: sizingInformation
                                                          .deviceScreenType ==
                                                      DeviceScreenType.mobile
                                                  ? 1
                                                  : sizingInformation
                                                              .deviceScreenType ==
                                                          DeviceScreenType
                                                              .tablet
                                                      ? (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2) ~/
                                                          220
                                                      : (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2) ~/
                                                          180,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: value.postListSaved!.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 25),
                                          child: MouseRegion(cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () => showAlertPost(
                                                  value.postListSaved![index]),
                                              child: PostTile(
                                                  post: value
                                                      .postListSaved![index]),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }),
                            )
                          : currentPage == 2
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Consumer<PostListProvider>(
                                      builder: (context, value, child) {
                                    if (value.loading) {
                                      return GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: sizingInformation
                                                              .deviceScreenType ==
                                                          DeviceScreenType
                                                              .mobile
                                                      ? 1
                                                      : sizingInformation
                                                                  .deviceScreenType ==
                                                              DeviceScreenType
                                                                  .tablet
                                                          ? (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2) ~/
                                                              220
                                                          : (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2) ~/
                                                              180,
                                                  crossAxisSpacing: 0,
                                                  mainAxisSpacing: 0),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: 8,
                                          itemBuilder: (BuildContext ctx,
                                                  index) =>
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 25),
                                                  child: LoadingPostTile()));
                                    } else if (value.postListForMe == null ||
                                        value.postListForMe!.isEmpty) {
                                      return SizedBox(
                                          width: 600,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Center(
                                              child: Text(
                                                tr("profile_screen_received_advice"),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ));
                                    } else {
                                      return GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: sizingInformation
                                                              .deviceScreenType ==
                                                          DeviceScreenType
                                                              .mobile
                                                      ? 1
                                                      : sizingInformation
                                                                  .deviceScreenType ==
                                                              DeviceScreenType
                                                                  .tablet
                                                          ? (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2) ~/
                                                              220
                                                          : (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2) ~/
                                                              180,
                                                  crossAxisSpacing: 0,
                                                  mainAxisSpacing: 0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              value.postListForMe!.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 25),
                                              child: GestureDetector(
                                                onTap: () => showAlertPost(value
                                                    .postListForMe![index]),
                                                child: PostTile(
                                                    post: value
                                                        .postListForMe![index]),
                                              ),
                                            );
                                          });
                                    }
                                  }),
                                )
                              : currentPage == 3
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Consumer<PostListProvider>(
                                          builder: (context, value, child) {
                                        if (value.loading) {
                                          return GridView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: sizingInformation
                                                                  .deviceScreenType ==
                                                              DeviceScreenType
                                                                  .mobile
                                                          ? 1
                                                          : sizingInformation
                                                                      .deviceScreenType ==
                                                                  DeviceScreenType
                                                                      .tablet
                                                              ? (MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      2) ~/
                                                                  220
                                                              : (MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                      2) ~/
                                                                  180,
                                                      crossAxisSpacing: 0,
                                                      mainAxisSpacing: 0),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: 8,
                                              itemBuilder: (BuildContext ctx,
                                                      index) =>
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 25),
                                                      child:
                                                          LoadingPostTile()));
                                        } else if (value.postListByMe == null ||
                                            value.postListByMe!.isEmpty) {
                                          return  SizedBox(
                                          width: 600,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Center(
                                              child: Text(
                                                tr("profile_screen_created_advice"),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ));
                                        } else {
                                          return GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: sizingInformation
                                                                  .deviceScreenType ==
                                                              DeviceScreenType
                                                                  .mobile
                                                          ? 1
                                                          : sizingInformation
                                                                      .deviceScreenType ==
                                                                  DeviceScreenType
                                                                      .tablet
                                                              ? (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      2) ~/
                                                                  220
                                                              : (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      2) ~/
                                                                  180,
                                                      crossAxisSpacing: 0,
                                                      mainAxisSpacing: 0),
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  value.postListByMe!.length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 25),
                                                  child: GestureDetector(
                                                    onTap: () => showAlertPost(
                                                        value.postListByMe![
                                                            index]),
                                                    child: PostTileByMe(
                                                        post:
                                                            value.postListByMe![
                                                                index]),
                                                  ),
                                                );
                                              });
                                        }
                                      }),
                                    )
                                  : sizingInformation.deviceScreenType !=
                                          DeviceScreenType.mobile
                                      ? const SizedBox.shrink()
                                      : Consumer<UserListProvider>(
                                          builder: (context, value, child) {
                                          if (value.loading) {
                                            return Center(
                                                child:
                                                    LoadingAnimationWidget.beat(
                                              color: const Color.fromARGB(
                                                  255, 255, 177, 59),
                                              size: 60,
                                            ));
                                          } else if (value.userListFollowing ==
                                                  null ||
                                              value
                                                  .userListFollowing!.isEmpty) {
                                            return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                child: Center(
                                                  child:
                                                      Text(tr("no_following")),
                                                ));
                                          } else {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: value
                                                    .userListFollowing!
                                                    .length, 
                                                itemBuilder:
                                                    (context, index) {
                                                  return GestureDetector(
                                                    onTap: () => AutoRouter
                                                            .of(context)
                                                        .push(ProfileDetailRoute(
                                                            uid: value
                                                                .userListFollowing![
                                                                    index]
                                                                .uid)),
                                                    child: NewProfessionalTileMobile(
                                                        user: value
                                                                .userListFollowing![
                                                            index]),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        }),
                    ),
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
                                    tr("connections"),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 600,
                                  width: 225,
                                  child: Consumer<UserListProvider>(
                                      builder: (context, value, child) {
                                    if (value.loading) {
                                      return SizedBox(
                                        height: 480,
                                        width: 225,
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return const LoaderNewProfessionalTile();
                                          },
                                        ),
                                      );
                                    } else if (value.userListFollowing ==
                                            null ||
                                        value.userListFollowing!.isEmpty) {
                                      return Center(
                                        child: Text(tr("no_following")),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: value.userListFollowing!.length > 4 ? 550 : value.userListFollowing!.length * 140,
                                            width: 225,
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: value
                                                          .userListFollowing!
                                                          .length >
                                                      4
                                                  ? 4
                                                  : value.userListFollowing!
                                                      .length, //this value can be at most 4
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () => AutoRouter.of(
                                                          context)
                                                      .push(ProfileDetailRoute(
                                                          uid: value
                                                              .userListFollowing![
                                                                  index]
                                                              .uid)),
                                                  child: NewProfessionalTile(
                                                      user: value
                                                              .userListFollowing![
                                                          index]),
                                                );
                                              },
                                            ),
                                          ),
                                          MouseRegion(
                                            cursor:
                                                SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  showFollowing(context, value.userListFollowing!),
                                              child: Text(
                                                tr("show_more"),
                                                style: const TextStyle(
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                    color: Color.fromARGB(
                                                        255,
                                                        140,
                                                        139,
                                                        139)),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  }),
                                ),
                              ],
                            ),
                          )
                  ]),
                  Container(
                    height: 140,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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


}
