import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final List<Color> background;
  final Color textColor;
   const Tag({
    Key? key,
    required this.text, 
    required this.background, 
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          height: 20,
          decoration: BoxDecoration(
              gradient:
                LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: background),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Center(
              child: Text(
                text, 
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style:  TextStyle(
                  color: textColor, 
                  fontWeight: FontWeight.w600, 
                  fontSize: 11
                ),)),
          ),
        ),
      ),
    );
  }
}
