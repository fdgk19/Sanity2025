import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenerateCodeAlert extends StatefulWidget {
  const GenerateCodeAlert({super.key});

  @override
  State<GenerateCodeAlert> createState() => _GenerateCodeAlertState();
}

class _GenerateCodeAlertState extends State<GenerateCodeAlert> {
  String randomCode = "";
  
 String randomString(int length) {
   const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random r = Random();
    return String.fromCharCodes(Iterable.generate(
    length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }
  @override
  void initState() {
    randomCode = randomString(8);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:  [
         Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child:  Text(tr("generated_code")),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(randomCode, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold) ,),
             IconButton(
                onPressed: () async{
                  Clipboard.setData(ClipboardData(text: randomCode)).then((_){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr("success_copycode"))));
                  });
                },
                icon: const Icon(
                  Icons.copy,
                  color: Color.fromARGB(255, 68, 68, 68))),
          ],
        ),
         Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SizedBox(
            width: 400,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr("text_alert_code")),
                const SizedBox(height: 6),
                Text(tr("warning_alert_code"), style: const TextStyle(color: Colors.red),),
              ],), 
            ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () {
              AutoRouter.of(context).pop();},
             child: Text(tr("back"), style: const TextStyle(color: Colors.red),),),
            TextButton(onPressed: () {
               AutoRouter.of(context).pop(randomCode);
            }, 
             child: Text(tr("yes"), style: const TextStyle(),),)


          ],
        )
      ],
    );
  }
}