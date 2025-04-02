import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/data/models/post_model.dart';
import 'package:sanity_web/presentations/widgets/post_detail_widgets/desktop_view/detail_screen_body_desktop.dart';
import 'package:sanity_web/presentations/widgets/post_detail_widgets/mobile_view/detail_screen_body_mobile.dart';
import 'package:sanity_web/presentations/widgets/post_detail_widgets/tablet_view/detail_screen_body_tablet.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;
  const PostDetailScreen({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
          minHeight: 50,
          maxHeight: 900, 
          minWidth: 900,
          maxWidth: 900
          // minWidth: MediaQuery.of(context).size.width,
          // maxWidth: MediaQuery.of(context).size.width 
        ),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "lib/resources/images/background.png",
                ),
                fit: BoxFit.fill),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: 
        ResponsiveBuilder(
            builder: (context, sizingInformation) => sizingInformation
                        .deviceScreenType ==
                    DeviceScreenType.desktop
                ?  DetailPostDesktop(post: widget.post,)
                :  sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ?  DetailPostTablet(post: widget.post,)
                :  DetailPostMobile(post: widget.post,)
                )
      );
  }
}

