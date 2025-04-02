import 'package:flutter/material.dart';

class ItemCreateButton extends StatefulWidget {
  final IconData icon;
  final String text;
  const ItemCreateButton({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  State<ItemCreateButton> createState() => _ItemCreateButtonState();
}

class _ItemCreateButtonState extends State<ItemCreateButton> {
  double _fontSize = 14;
  double _iconSize = 25;
  Color color = Colors.transparent;
  Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _fontSize = 14;
          _iconSize = 25;
          color = Colors.white;
          textColor = Colors.black;
        });
      },
      onExit: (event) {
        setState(() {
          _fontSize = 14;
          _iconSize = 25;
          color = Colors.transparent;
          textColor = Colors.white;
        });
      },
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: _iconSize, color: textColor),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor, fontSize: _fontSize),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
