import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/edit_post_alert.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/clone_draft_widgets/clone_draft_error.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/loader_professional_tile.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/professional_tile.dart';

import '../../state_management/auth_provider.dart';
import '../../state_management/new_post_provider.dart';
import 'clone_draft_widgets/clone_draft_success.dart';

class PostTileByMe extends StatefulWidget {
  final PostModel post;
  const PostTileByMe({Key? key, required this.post}) : super(key: key);

  @override
  State<PostTileByMe> createState() => _PostTileByMeState();
}

class _PostTileByMeState extends State<PostTileByMe> {
  Offset? _tapSectionPosition;


  UserModel? userPost;

  @override
  void initState() {
   _tapSectionPosition = const Offset(0, 0);
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      userPost = await context.read<UserListProvider>().getPostUserDetail(userId: widget.post.doctorId);
      if(mounted){
        setState(() {});
      }
   }); 
   super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.1),
          borderRadius: const BorderRadius.all(Radius.circular(13))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
               //publisher info
            Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 10.0),
              child: userPost == null 
              ? const LoaderProfessionalTile()
              : SizedBox(
                width: 230,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfessionalTile(
                          user: userPost!,
                        ),
                   Padding(
                     padding: const EdgeInsets.only(left:0.0,top:0),
                     child: GestureDetector(
                     onTapDown:  _storeSectionPosition,
                     onTap:() async{
                       if( widget.post.reedemableCode == null){
                        await _showSectionPopupMenu(context);
                       } else {
                        await _showSectionPopupMenuwithcode(context);
                       }
                     },
                    //  onTap: () async =>
                    //    widget.post.reedemableCode != null ?  await _showSectionPopupMenuwithcode(context)
                    //    : await _showSectionPopupMenu(context),
                     child: SvgPicture.asset("lib/resources/images/menu-dot-vertical.svg",color: Colors.grey, width: 25, height: 25,),
                       ),
                   )
                  ],
                ),
              )
            ),
            //postinfo
           Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  Container(
                    width: 250,
                    height: 160,
                    decoration: BoxDecoration(
                        image: widget.post.mainImage != null 
                        ? DecorationImage(
                          image: NetworkImage(widget.post.mainImage!), fit: BoxFit.cover,)
                        : const DecorationImage(image: AssetImage(
                                  "lib/resources/images/sanityplaceholder.png"),
                                   fit: BoxFit.cover,),
                        //borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        //borderRadius: BorderRadius.circular(12)
                        ),
                  ),
                  Container(
                    height: 159,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        )
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        height: 0,
                        thickness: 1.5,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      widget.post.tags == null
                          ?  Padding(
                              padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return  Container(
                                          width: 35,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(255, 227, 227, 227),
                                            borderRadius: BorderRadius.all(Radius.circular(4))
                                          ),
                                        );
                                      },
                                    ),
                                  )),
                            )
                    
                          : Padding(
                              padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.post.tags!.length < 4
                                          ? widget.post.tags!.length
                                          : 4,
                                      itemBuilder: (context, index) {
                                        if (index == 3) {
                                          return Center(
                                              child: SvgPicture.asset(
                                                  width: 10,
                                                  height: 10,
                                                  color: Colors.white,
                                                  "lib/resources/images/menu-dot-horizontal.svg"));
                                        }
                                        return Container(
                                          constraints:
                                              const BoxConstraints(maxWidth: 75),
                                          child: Tag(
                                            text: widget.post.tags![index],
                                            background: const [Colors.white, Colors.white],
                                            textColor: Colors.black,
                                          ),
                                        );
                                      },
                                    ),
                                  )),
                            ),
                          const SizedBox(height: 0,),
                           Row(
                             children: [
                               SizedBox(
                                height: 50,
                                width: 250,
                                 child: Padding(
                                   padding: const EdgeInsets.only(left:7, top:12, right:7, bottom: 5),
                                   child: Text(
                                    widget.post.mainTitle, maxLines: 2,
                                    style: const TextStyle(
                                        //possibile problema con post sfondo bianco
                                        color: Colors.black, fontSize:13, overflow: TextOverflow.ellipsis),
                                    ),
                                 ),
                               ),
                             ],)
                    ],),
                ],),
            ),
            ],),
      ),
    );
  }

  void _storeSectionPosition(TapDownDetails details) {
    _tapSectionPosition = details.globalPosition;
  }

  //todo add index e metodo remove e modifica post
  _showSectionPopupMenu(BuildContext context) async {
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
        PopupMenuItem<int>(value: 3, child: Text(tr("create_draft"))),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value != null) {
        switch (value) {
          case 1:
            await context.read<NewPostProvider>().initDraftPost(postId: widget.post.pid);
            await showDialog(barrierDismissible: false, context: context, builder: (context) => EditPostAlert(post: widget.post, sectionLenght: context.read<NewPostProvider>().sectionList.length,));
            break;
          case 2:
            await context.read<PostListProvider>().deletePostByMe(widget.post);
            break;
          case 3:
          var user = context.read<AuthProvider>().currentUser;
              if(user.counterFreePost >= 3 && !user.isPremium){
                await showDialog(context: context, builder: (context) {
                  return  AlertDialog(
                    content: Column(
                      children: [
                        Text(tr("no_create_post_body",), textAlign: TextAlign.center),
                         Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  AutoRouter.of(context).pop();
                                },
                                child: Text(tr("confirm"))),
                          )
                      ],
                    ),
                  );
                },);
              } else {
                  bool response = await context.read<NewPostProvider>().clonePost(post: widget.post);
                  if (response) {
                    await showDialog(
                      barrierDismissible: false,
                     context: context,
                     builder: (context) {
                      return const AlertDialog(
                        content: CloneDraftSucces()
                      );
                    },);
                  } else {
                    await showDialog(context: context,      
                     barrierDismissible: false,
                     builder: (context) {
                      return const AlertDialog(
                        content: CloneDraftError(),
                      );
                    },);
                  }
              }
            break;
        }
      }
    });
  }

  _showSectionPopupMenuwithcode(BuildContext context) async {
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
        PopupMenuItem<int>(value: 3, child: Text(tr("code"))),
        PopupMenuItem<int>(value: 4, child: Text(tr("create_draft"))),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value != null) {
        switch (value) {
          case 1:
            await context.read<NewPostProvider>().initDraftPost(postId: widget.post.pid);
            await showDialog(barrierDismissible: false, context: context, builder: (context) => EditPostAlert(post: widget.post, sectionLenght: context.read<NewPostProvider>().sectionList.length,));
            break;
          case 2:
            await context.read<PostListProvider>().deletePostByMe(widget.post);
            break;
          case 3: 
            await Clipboard.setData(ClipboardData(text: widget.post.reedemableCode));
            break;
          case 4:
              var user = context.read<AuthProvider>().currentUser;
              if(user.counterFreePost >= 3 && !user.isPremium){
                await showDialog(context: context, builder: (context) {
                  return  AlertDialog(
                    content: Column(
                      children: [
                        Text(tr("no_create_post_body",), textAlign: TextAlign.center),
                         Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  AutoRouter.of(context).pop();
                                },
                                child: Text(tr("confirm"))),
                          )
                      ],
                    ),
                  );
                },);
              } else {
                  bool response = await context.read<NewPostProvider>().clonePost(post: widget.post);
                  if (response) {
                    await showDialog(context: context, builder: (context) {
                      return const AlertDialog(
                        content: CloneDraftSucces()
                      );
                    },);
                  } else {
                    await showDialog(context: context, builder: (context) {
                      return const AlertDialog(
                        content: CloneDraftError(),
                      );
                    },);
                  }
              }
            break;
        }
      }
    });
  }

}
