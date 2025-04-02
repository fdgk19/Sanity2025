
import 'package:flutter/material.dart';

class SettingHorizontalItem extends StatelessWidget {
  final String text;
  final Color color;
  const SettingHorizontalItem({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:15.0),
            child: Text(text, style:  TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600),),
          )
          ],
      ),
    );
  }
}