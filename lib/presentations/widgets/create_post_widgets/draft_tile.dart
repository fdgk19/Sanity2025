import 'package:flutter/material.dart';

class DraftTile extends StatelessWidget {
  final String draftTitle;
  const DraftTile({Key? key, required this.draftTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 175,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 12),
          child: Text(
            draftTitle,
          ),
        ),
      ),
    );
  }
}