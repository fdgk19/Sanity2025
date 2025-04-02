import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/presentations/pages/post_detail_screen.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tile.dart';

import '../other_widgets/loader_post_tile.dart';

class SavedBody extends StatefulWidget {
  const SavedBody({super.key, required this.doctorId});
  final String doctorId;
  

  @override
  State<SavedBody> createState() => _SavedBodyState();
}

class _SavedBodyState extends State<SavedBody> {

  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PostListProvider>().getPostsByMePublic(doctorId: widget.doctorId);
    });
    super.initState();
  }


  final ScrollController controller = ScrollController();

  void showAlertPost(PostModel post) async {
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0))),
              contentPadding: const EdgeInsets.only(top: 0.0),
              content: SizedBox(
                width: 900,
                child:  PostDetailScreen(post:post),
              ),
            ));
    }


  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20),
          child: Consumer<PostListProvider>(
            builder: (context, value, child) {
              if (value.loading) {
                return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: sizingInformation.deviceScreenType ==
                                  DeviceScreenType.mobile
                              ? 2
                              : sizingInformation.deviceScreenType ==
                                      DeviceScreenType.tablet
                                  ? 3
                                  : 3,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (BuildContext ctx, index) {
                        return const Padding(
                          padding:  EdgeInsets.only(right: 25),
                          child:  LoadingPostTile(),
                        );
                      });
              } else if (value.postListByMePublic == null ||
                  value.postListByMePublic!.isEmpty) {
                return SizedBox(
                    width: 600,
                    height:
                        MediaQuery.of(context).size.height /
                            2,
                    child: Center(
                      child: Text(tr("pro_not_publish_yet")),
                    ));
              } else {
                return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: sizingInformation.deviceScreenType ==
                                  DeviceScreenType.mobile
                              ? 2
                              : sizingInformation.deviceScreenType ==
                                      DeviceScreenType.tablet
                                  ? 3
                                  : 3,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: value.postListByMePublic!.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: GestureDetector(
                             onTap: ()  {
                                showAlertPost( value.postListByMePublic![index]);
                             },
                            child: PostTile(
                              post: value.postListByMePublic![index]),
                          ),
                        );
                      });
              }
            }
          ),
        ),
      ),
    );
  }
}
