import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final bool isActive;
  final Function switchItem;
  final IconData iconActive;
  final IconData iconNotActive;
  const NavBarItem(
      {Key? key,
      required this.switchItem,
      required this.isActive,
      required this.iconActive,
      required this.iconNotActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => {
                switchItem()
                },
              child: Icon(
                isActive ? iconActive : iconNotActive,
                color: Colors.white,
                size: 30,
              )),
          const SizedBox(
            height: 3,
          ),
          Container(
            width: 23,
            height: 2,
            decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
          ),
        ],
      ),
    );
  }
}
