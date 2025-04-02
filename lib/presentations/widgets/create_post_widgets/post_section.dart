import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String text;
  final Color textColor;
   const Section({
    Key? key,
    required this.text, 
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          width: 170,
          height: 30,
          decoration: BoxDecoration(
             gradient: const LinearGradient(
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                  colors:  [  
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 225, 225, 225)],),
    
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
                style: TextStyle(
                  color: textColor, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 13
                ),)),
          ),
        ),
      ),
    );
  }
}
