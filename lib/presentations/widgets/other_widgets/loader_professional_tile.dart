import 'package:flutter/material.dart';

class LoaderProfessionalTile extends StatelessWidget {

  const LoaderProfessionalTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
                const CircleAvatar(
                radius: 16,
                backgroundColor: Color.fromARGB(255, 227, 227, 227),
                   ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                       width: 120,
                       height: 20,
                       decoration: const BoxDecoration(
                         color: Color.fromARGB(255, 227, 227, 227),
                         borderRadius: BorderRadius.all(Radius.circular(4))
                       ),
                      ),
                      const SizedBox(height: 3,),
                     Container(
                            width: 50,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 227, 227, 227),
                              borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                           )
                  ],
                ),
              ),
            ],
          ),
        );
  }
}