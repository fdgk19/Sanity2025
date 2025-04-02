import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FooterSocialItem extends StatelessWidget {
  final String icon;
  const FooterSocialItem({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(7))
        ),
        
        child: Center(
            child: SvgPicture.asset(
          icon,
          color: Colors.black,
          width: 20,
          height: 20,
        )),
      ),
    );
  }
}
