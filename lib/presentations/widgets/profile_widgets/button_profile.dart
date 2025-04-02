import 'package:flutter/material.dart';

class ButtonProfile extends StatelessWidget {
  final String text;
  const ButtonProfile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 235, 235),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.4,
                                blurRadius: 3,
                                offset:
                                    const Offset(0, 3) // changes position of shadow
                                ),
                          ],
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Text(text,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
  }
}