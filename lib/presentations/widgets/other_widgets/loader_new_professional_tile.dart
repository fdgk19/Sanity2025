import 'package:flutter/material.dart';

class LoaderNewProfessionalTile extends StatelessWidget {
  const LoaderNewProfessionalTile({Key? key, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 227, 227, 227),
            radius: 40,
          ),
       
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Container(
              width: 120,
              height: 14,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 227, 227, 227),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:3.0),
            child: Container(
              width: 80,
              height: 14,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 227, 227, 227),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          )
        ],
      ),
    );
  }
}
