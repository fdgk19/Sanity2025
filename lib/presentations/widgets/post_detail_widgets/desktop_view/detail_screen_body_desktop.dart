import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/presentations/state_management/post_detail_provider.dart';
import 'package:sanity_web/presentations/widgets/post_detail_widgets/section_list_item.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';
import 'package:sanity_web/presentations/widgets/post_detail_widgets/section_viewer.dart';

class DetailPostDesktop extends StatefulWidget {
  final PostModel post;
  const DetailPostDesktop({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailPostDesktop> createState() => _DetailPostDesktopState();
}

class _DetailPostDesktopState extends State<DetailPostDesktop> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<PostDetailProvider>()
          .getPostDetails(post: widget.post);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostDetailAppBar(),
          Divider(
            thickness: 2,
            color: Colors.white,
          ),
          DetailPostDesktopBody()
        ],
      ),
    );
  }
}

class PostDetailAppBar extends StatelessWidget {
  const PostDetailAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Consumer<PostDetailProvider>(builder: (context, value, child) {
        if (value.loadingDetails || value.postDetails == null) {
           return Center(
          child: LoadingAnimationWidget.beat(
        color: const Color.fromARGB(255, 255, 177, 59),
        size: 60,
      ));
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 400,
                    child: Text(
                      value.postDetails!.mainTitle,
                      maxLines: 1,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      formattedDate(value.postDetails!.date),
                      //todo formatta data everywhere
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                       mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async{
                              if(value.isFavorite){
                                await context.read<PostDetailProvider>().removeLike();
                              }else{
                                await context.read<PostDetailProvider>().addLike();
                              }
                            },
                            icon: Icon(
                              value.isFavorite 
                              ? Icons.save
                              : Icons.save_outlined, 
                              color: Colors.white)),
                              
                        Text( 
                          value.isFavorite
                          ? tr("issaved")
                          : tr("save"), 
                          style: const TextStyle(fontSize: 11, color: Colors.white),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () async{
                            Clipboard.setData(ClipboardData(text: "https://sanity-health.com/#/profiledetail/${value.postDetails!.doctorId}/post/${value.postDetails!.pid}")).then((_){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link copiato negli appunti")));
                            });
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.white)),
                            Text( tr("share"), style: const TextStyle(fontSize: 11, color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      }),
    );
  }
}

class DetailPostDesktopBody extends StatefulWidget {
  const DetailPostDesktopBody({Key? key}) : super(key: key);

  @override
  State<DetailPostDesktopBody> createState() => _DetailPostDesktopBodyState();
}

class _DetailPostDesktopBodyState extends State<DetailPostDesktopBody>
    with SingleTickerProviderStateMixin {
  bool isSectionOpened = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 470,
      child: Stack(
        children: [
          //PostMainInfo
          AnimatedPositioned(
            left: isSectionOpened ? -375 : 20,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //PostMainInfo
                  Consumer<PostDetailProvider>(
                      builder: (context, value, child) {
                    if (value.loadingDetails || value.userDetail == null) {
                       return Center(
                          child: LoadingAnimationWidget.beat(
                        color: const Color.fromARGB(255, 255, 177, 59),
                        size: 60,
                      ));
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              value.userDetail!.photoUrl == null ||
                                      value.userDetail!.photoUrl!.isEmpty
                                  ? const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 16,
                                      backgroundImage: AssetImage(
                                          "lib/resources/images/logosanity.png"))
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                          value.userDetail!.photoUrl!)),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => AutoRouter.of(context).push(
                                        ProfileDetailRoute(
                                            uid: value.userDetail!.uid)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                  constraints: const BoxConstraints(maxWidth: 220),
                                              child: Text(
                                                "${value.userDetail!.name} ${value.userDetail!.surname}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, left: 2),
                                                child: value
                                                        .userDetail!.isPremium
                                                    ? SvgPicture.asset(
                                                        width: 16,
                                                        height: 16,
                                                        color: Colors.blue,
                                                        "lib/resources/images/certificate.svg")
                                                    : const SizedBox.shrink()),
                                          ],
                                        ),
                                        Text(
                                          value.userDetail!.mainProfesion ??
                                              " ",
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 300,
                                maxWidth: 350,
                              ),
                              decoration: BoxDecoration(
                                  image: value.postDetails!.mainImage != null
                                      ? DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(
                                              value.postDetails!.mainImage!))
                                      : const DecorationImage(
                                          image: AssetImage(
                                              "lib/resources/images/sanityplaceholder.png"),
                                          fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12),
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: 350,
                                  maxHeight: 25,
                                  minWidth: 350,
                                  minHeight: 25),
                              child: Consumer<PostDetailProvider>(
                                  builder: (context, value, child) {
                                if (value.loadingDetails ||
                                    value.postDetails == null) {
                                    return Center(
                                      child: LoadingAnimationWidget.beat(
                                    color: const Color.fromARGB(255, 255, 177, 59),
                                    size: 60,
                                  ));
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: value.postDetails!.tags == null
                                        ? 0
                                        : value.postDetails!.tags!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 75),
                                        child: Tag(
                                          text: value.postDetails!.tags![index],
                                          background: const [
                                            Colors.white,
                                            Colors.white
                                          ],
                                          textColor: Colors.black,
                                        ),
                                      );
                                    },
                                  );
                                }
                              }),
                            ),
                          ),
                        ],
                      );
                    }
                  }), //PostSectionList
                  Container(
                      padding: const EdgeInsets.only(left: 32, top: 16),
                      constraints: const BoxConstraints(
                        maxWidth: 375,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isSectionOpened
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSectionOpened = !isSectionOpened;
                                            selectedIndex = -1;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 17,
                                          color: Colors.white,
                                        ))
                                    : const SizedBox.shrink(),
                                Text(
                                  tr("sections"),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Consumer<PostDetailProvider>(
                              builder: (context, value, child) {
                            if (value.loadingDetails ||
                                value.postDetails == null) {
                               return Center(
                                  child: LoadingAnimationWidget.beat(
                                color: const Color.fromARGB(255, 255, 177, 59),
                                size: 60,
                              ));
                            } else {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: value.postDetails!.section!.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () async {
                                            if (!isSectionOpened) {
                                              isSectionOpened =
                                                  !isSectionOpened;
                                            }
                                            context.read<PostDetailProvider>().startMediaDetailsOperation();
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                            await Future.delayed(const Duration(milliseconds: 500), () => context.read<PostDetailProvider>().endMediaDetailsOperation());
                                          },
                                          child: SectionListItem(
                                              sections: value
                                                  .postDetails!.section![index],
                                              isSelected:
                                                  selectedIndex == index)));
                            }
                          }),
                        ],
                      )),
                  //SectionDescriptionView
                  AnimatedOpacity(
                      opacity: isSectionOpened ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Colors.white,
                            ),
                            width: 475,
                            height: 450,
                            child: SectionViewer(
                              sectionIndex: selectedIndex,
                            )),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
