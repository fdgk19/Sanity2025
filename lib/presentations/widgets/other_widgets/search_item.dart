import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchItem extends StatefulWidget {
  const SearchItem(
      {super.key,
      required this.name,
      required this.surname,
      required this.mainProfession,
      required this.isPro,
      required this.image});
  final String name;
  final String surname;
  final String mainProfession;
  final bool isPro;
  final String? image;

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (widget.image != null && widget.image!.isNotEmpty)
            ? CircleAvatar(
                radius: 27,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.image!))
            : const CircleAvatar(
                radius: 27,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage("lib/resources/images/profile_placeholder.png")),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "${widget.name} ${widget.surname}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 2),
                    child: widget.isPro
                        ? SvgPicture.asset(
                            width: 11,
                            height: 11,
                            color: Colors.blue,
                            "lib/resources/images/certificate.svg")
                        : const SizedBox.shrink(),
                  )
                ]),
                SizedBox(
                  width: 100,
                  child: Text(
                    widget.mainProfession,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
