import 'package:flutter/material.dart';
import 'package:sanity_web/data/models/section_model.dart';

class SectionListItem extends StatelessWidget {
  final SectionModel sections;
  final bool isSelected;
  const SectionListItem({super.key, required this.sections, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Container(  
        decoration:  BoxDecoration(
            color: isSelected ? const Color.fromARGB(255, 209, 209, 209) :Colors.white,
            border: Border.all(color: Colors.black, width: 0.2),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(sections.title, 
          overflow: TextOverflow.ellipsis, maxLines: 1,),
        ),
      ),
    );
  }
}


