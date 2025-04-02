
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/desktop_view/create_sections_desktop_body.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/mobile_view/create_sections_mobile_body.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/tablet_view/create_sections_tablet_body.dart';

class AddSection extends StatefulWidget {
  final int index;
  const AddSection({super.key, required this.index});

  @override
  State<AddSection> createState() => _AddSectionState();
}

class _AddSectionState extends State<AddSection> {

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) =>
            sizingInformation.deviceScreenType == DeviceScreenType.mobile
                ? AddSectionMobile(index: widget.index)
                :  sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? AddSectionTablet(index: widget.index)
                : AddSectionDesktop(index: widget.index,));
  }
}
