import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingItem extends StatelessWidget {
  final String? icon;
  final String text;
  final Color color;
  const SettingItem({super.key, this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon!, color: color,width: 26, height: 26,),
          Padding(
            padding: const EdgeInsets.only(left:15.0),
            child: Text(text, style:  TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w600),),
          )
          ],
      ),
    );
  }
}


