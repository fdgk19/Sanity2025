import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/loader_professional_tile.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/professional_tile.dart';

class PostTile extends StatefulWidget {
  final PostModel post;
  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {

  UserModel? userPost;

  @override
  void initState() {
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
              : ProfessionalTile(
                    user: userPost!,
                  )
            ),
            //postinfo
            Container(
              width: 250,
              height: 205,
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
                                        color: Colors.black, fontSize: 13, overflow: TextOverflow.ellipsis),
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
}
