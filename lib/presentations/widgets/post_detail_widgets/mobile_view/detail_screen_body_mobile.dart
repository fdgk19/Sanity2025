import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/presentations/state_management/post_detail_provider.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';
import 'package:sanity_web/presentations/widgets/post_detail_widgets/section_viewer.dart';

import '../../../../commons/utils.dart';
import '../section_list_item.dart';
class DetailPostMobile extends StatefulWidget {
  final PostModel post;
  const DetailPostMobile({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailPostMobile> createState() => _DetailPostMobileState();
}

class _DetailPostMobileState extends State<DetailPostMobile> {

  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<PostDetailProvider>().getPostDetails(post: widget.post);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          PostDetailAppBarMobile(),
          Divider(
            thickness: 2,
            color: Colors.white,
          ),
          DetailPostMobileBody()
        ],
      ),
    );
  }
}

class PostDetailAppBarMobile extends StatelessWidget {
  const PostDetailAppBarMobile({Key? key}) : super(key: key);

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
                    width: 180,
                    child: Text(
                      value.postDetails!.mainTitle,
                      maxLines: 2,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      formattedDate(value.postDetails!.date),
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
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
                        Text(value.isFavorite
                          ? tr("issaved")
                          : tr("save"),
                           style: const TextStyle(fontSize: 10, color: Colors.white),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () async{
                            Clipboard.setData(ClipboardData(text: "https://sanity-health.com/#/profiledetail/${value.postDetails!.doctorId}/post/${value.postDetails!.pid}")).then((_){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link copiato negli appunti")));
                            });
                          },
                          icon: const Icon(
                            Icons.link,
                            color: Colors.white)),
                            Text( tr("share"), style: const TextStyle(fontSize: 10, color: Colors.white),),
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

class DetailPostMobileBody extends StatefulWidget {
  const DetailPostMobileBody({Key? key}) : super(key: key);

  @override
  State<DetailPostMobileBody> createState() => _DetailPostMobileBodyState();
}

class _DetailPostMobileBodyState extends State<DetailPostMobileBody> with SingleTickerProviderStateMixin{

  bool isSectionOpened = false;
  int selectedIndex = -1;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 8, left: 8),
      child: SizedBox(
        height: 550,
        child: AnimatedCrossFade(
          firstChild: sectionClosed(),
          secondChild: sectionOpened(),
          crossFadeState: isSectionOpened ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 500),

        ),
      ),
    );
  }

  Widget sectionOpened(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //PostSectionList
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
                  Column(
                    children: [
                      Text(
                        tr("sections"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(tr("show"), style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 15, color: Colors.white),)
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Consumer<PostDetailProvider>(
                builder: (context, value, child){
                   if (value.loadingDetails || value.postDetails == null) {
                         return Center(
                          child: LoadingAnimationWidget.beat(
                        color: const Color.fromARGB(255, 255, 177, 59),
                        size: 60,
                      ));
                   } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                      shrinkWrap: true,
                      itemCount: value.postDetails!.section!.length,
                      itemBuilder: (context, index) =>
                          GestureDetector(
                            onTap: () async {
                              if(!isSectionOpened){
                                isSectionOpened = !isSectionOpened;
                              }
                              context.read<PostDetailProvider>().startMediaDetailsOperation();
                              setState(() {
                                selectedIndex = index;
                              });
                              await Future.delayed(const Duration(milliseconds: 500), () => context.read<PostDetailProvider>().endMediaDetailsOperation());
                            },
                            child: SectionListItem(
                              sections: value.postDetails!.section![index],
                              isSelected: selectedIndex == index
                            )));
                }}
              ),
            ),
            //SectionDescriptionView
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.white,
                ),
                  width: 450,
                  height: 450,
                  child: SectionViewer(
                    sectionIndex: selectedIndex,
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget sectionClosed(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: SingleChildScrollView(
        child: Consumer<PostDetailProvider>(
          builder: (context, value, child) {
              if (value.loadingDetails || value.userDetail == null) {
                  return Center(
                          child: LoadingAnimationWidget.beat(
                        color: const Color.fromARGB(255, 255, 177, 59),
                        size: 60,
                      ));
             } else {
            return Column(
              children: [
                //ProfessionalInfo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     value.userDetail!.photoUrl == null || value.userDetail!.photoUrl!.isEmpty 
                            ? const CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 30,
                              backgroundImage:  AssetImage("lib/resources/images/logosanity.png")
                                )
                            : CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 30,
                              backgroundImage:  NetworkImage(value.userDetail!.photoUrl!)
                                ),
                         
                          
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => AutoRouter.of(context).push(ProfileDetailRoute(uid: value.userDetail!.uid)),
                                    child: Text(
                                      "${value.userDetail!.name} ${value.userDetail!.surname}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, left: 2),
                                    child: value.userDetail!.isPremium
                                               ? SvgPicture.asset(
                                                  width: 16,
                                                  height: 16,
                                                  color: Colors.blue,
                                                  "lib/resources/images/certificate.svg")
                                                : const SizedBox.shrink()
                                            
                                  ),
                                ],
                              ),
                            ],
                          ),
                           Text(
                            value.userDetail!.mainProfesion ?? "",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //PostImageBox  
                //PostTags
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                      maxHeight: 25,
                      minWidth: 100,
                      minHeight: 25
                    ),
                    child: Consumer<PostDetailProvider>(
                      builder: (context, value, child) {
                          if (value.loadingDetails || value.postDetails == null) {
                                  return Center(
                          child: LoadingAnimationWidget.beat(
                        color: const Color.fromARGB(255, 255, 177, 59),
                        size: 60,
                      ));
                           } else {
                         return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: value.postDetails!.tags == null ? 0 :value.postDetails!.tags!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            constraints:
                                const BoxConstraints(maxWidth: 75),
                            child:  Tag(
                              text:  value.postDetails!.tags![index],
                              background: const [Colors.white, Colors.white],
                              textColor: Colors.black,
                            ),
                          );
                        },
                      );
                      }}
                    
                  ),
                  )),
                //PostSectionList
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8),
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
                      Column(
                        children: [
                          Text(
                            tr("sections"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(tr("show"), style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 15, color: Colors.white),)
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Consumer<PostListProvider>(
                    builder: (context, value, child) {
                       return Consumer<PostDetailProvider>(
                         builder: (context, value, child) {
                          if (value.loadingDetails || value.postDetails == null) {
                                  return Center(
                          child: LoadingAnimationWidget.beat(
                        color: const Color.fromARGB(255, 255, 177, 59),
                        size: 60,
                      ));
                            } else {
                           return ListView.builder(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                              shrinkWrap: true,
                              itemCount: value.postDetails!.section!.length,
                              itemBuilder: (context, index) =>
                                  GestureDetector(
                                    onTap: () async {
                                      if(!isSectionOpened){
                                        isSectionOpened = !isSectionOpened;
                                      }
                                      context.read<PostDetailProvider>().startMediaDetailsOperation();
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                      await Future.delayed(const Duration(milliseconds: 500), () => context.read<PostDetailProvider>().endMediaDetailsOperation());
                                    },
                                    child: SectionListItem(
                                      sections: value.postDetails!.section![index],
                                      isSelected: selectedIndex == index
                                    )));
                         }}
                       );
                    }
                  ),
                ),
              ],
            );
                               }   }
        ),
      ),
    );
  }
}
