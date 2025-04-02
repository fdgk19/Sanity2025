import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;


class SignUpThirdTab extends StatefulWidget {
   final Function(bool isDoctor) goNext;
  final Function() goBack;
  const SignUpThirdTab({
    Key? key,
    required this.goBack,
    required this.goNext
  }) : super(key: key);

  @override
  State<SignUpThirdTab> createState() => _SignUpThirdTabState();
}

class _SignUpThirdTabState extends State<SignUpThirdTab> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  bool isYes = false;
  bool isContractSigned = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              tr("is_doctor_question"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: MouseRegion(
                    
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isYes = true;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                            child: Text(
                          tr("yes"),
                          style: const TextStyle(color: Colors.black),
                        )),
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => widget.goNext(false),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Text(
                        tr("no"),
                        style: const TextStyle(color: Colors.black),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isYes ? 
          Padding(
            padding: const EdgeInsets.only(top:50.0),
            child: Row(
              children: [
                Checkbox(
                    side: const BorderSide(
                        color: Colors.white,
                        width: 1.5),
                    value: isContractSigned,
                    activeColor: Colors.green,
                    onChanged: (bool? value) {
                      setState(() {
                        isContractSigned = value!;
                        
                      });
                    },
                  ),
                GestureDetector(
                  onTap: () async {
                        var laureaRef = "https://firebasestorage.googleapis.com/v0/b/sanity-ef53f.appspot.com/o/sanity_documents%2Flicenza.pdf?alt=media&token=01e9cd10-5f0b-4d25-9056-028c01aac3fa";
                        if(laureaRef.isNotEmpty)
                        {
                          html.window.open(laureaRef, "");
                          //downloadFile(laureaRef); 
                        }
                      },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(tr("sign_contract"), style:const TextStyle(color: Colors.white, decoration: TextDecoration.underline),)))
              ],
            ),
          )
          : const SizedBox.shrink(),
          isYes && isContractSigned ?
          GestureDetector(
            onTap: () => widget.goNext(true),
            child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      constraints: const BoxConstraints(
                          maxHeight: 45,
                          maxWidth: 400,
                          minHeight: 30,
                          minWidth: 100),
                      child: Center(
                          child: Text(
                        tr("continue"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
          )
          : const SizedBox.shrink(),
           Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => widget.goBack() ,
                        child: Text(
                          tr("back_to_previous"),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
