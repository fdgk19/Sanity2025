import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  final String mainText;
  final Function() buttonPress;
  const CustomGradientButton({Key? key, required this.mainText, required this.buttonPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton (
      onPressed: () => buttonPress(),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0))),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0.0))
      ), 
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
                Colors.red,
                Colors.blue,
                Colors.green
            ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), 
          alignment: Alignment.center,
          child: Text(
            mainText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}