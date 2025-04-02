import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/presentations/state_management/post_detail_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/section_element_item.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/section_element_item_last.dart';

class SectionViewer extends StatefulWidget {
  final int sectionIndex;
  const SectionViewer({Key? key, required this.sectionIndex}) : super(key: key);

  @override
  State<SectionViewer> createState() => _SectionViewerState();
}

class _SectionViewerState extends State<SectionViewer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailProvider>(
      builder: (context, value, child) {
        if (value.loadingMediaDetails ||
            value.postDetails == null) {
           return Center(
          child: LoadingAnimationWidget.beat(
            color: const Color.fromARGB(255, 255, 177, 59),
            size: 60,
          ));
        } else {
          return ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.sectionIndex >= 0 
            ? value.postDetails!.section![widget.sectionIndex].sectionMediaList!.length
            : 0,
            itemBuilder: (context, index) => 
              index < value.postDetails!.section![widget.sectionIndex].sectionMediaList!.length - 1
              ? SectionElementItem(
                onMediaTap:() {},
                onMediaTapDown: (details) {},
                media: value.postDetails!.section![widget.sectionIndex].sectionMediaList![index],
                isReadOnly: true,
              )
              : SectionElementItemLast(
                onMediaTap:() {},
                onMediaTapDown: (details) {},
                media: value.postDetails!.section![widget.sectionIndex].sectionMediaList![index],
                isReadOnly: true,
              )
          );
        }
      },
    );
  }
}