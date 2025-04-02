// ignore_for_file: avoid_print
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';

class SignUpFifthTab extends StatefulWidget {
  final Function() goNext;
  const SignUpFifthTab({
    Key? key,
    required this.goNext, 
  }) : super(key: key);

  @override
  State<SignUpFifthTab> createState() => _SignUpFifthTabState();
}

class _SignUpFifthTabState extends State<SignUpFifthTab> {
  PlatformFile? docCV;
  PlatformFile? docLaurea;
  String? resCV ="";
  String? resLaurea ="";

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("enter_document_description"),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
            tr("enter_document_format"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 6),
            child: Text(
            tr("enter_document_cv"),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var file = await fileFromStorage(documentExtSupported);
              if (file == null && mounted) {
                showerrortoast(tr("error_dimension"),context);
              }
              setState(() {
                docCV = file;
              });
            },
            child: Container(
                height: 37,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: Row(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 216, 216, 216),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Center(child: Text(tr("enter_document_file")))),
                    const VerticalDivider(
                      width: 0,
                      color: Colors.black,
                      thickness: 0.25,
                    ),
                    Expanded(
                      child: Padding(
                        padding:const EdgeInsets.only(left: 10.0, right: 10),
                        child: Text(
                          docCV == null ? tr("enter_document_no_file") : docCV!.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ), 
                      ),
                    )
                  ],
                )),
          ),
           Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 6),
            child: Text(
              tr("enter_document_degree"),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var file = await fileFromStorage(documentExtSupported);
              setState(() {
                docLaurea = file;
              });
            },
            child: Container(
                height: 37,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: Row(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 216, 216, 216),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Center(child: Text(tr("enter_document_file")))),
                    const VerticalDivider(
                      width: 0,
                      color: Colors.black,
                      thickness: 0.25,
                    ),
                    Expanded(
                      child: Padding(
                        padding:const EdgeInsets.only(left: 10.0, right: 10),
                        child: Text(
                          docLaurea == null ? tr("enter_document_no_file") : docLaurea!.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ), 
                      ),
                    )
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: AbsorbPointer(
              absorbing: docCV == null && docLaurea == null,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    if(docCV != null){
                      resCV = await Provider.of<AuthProvider>(context, listen: false).uploadFile(docCV!, "cv");
                    }
                    if(docLaurea != null && mounted){
                        resLaurea = await Provider.of<AuthProvider>(context, listen: false).uploadFile(docLaurea!, "degree");
                    }
            
                    if(resCV == null || resLaurea == null){
                      await showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: Text(tr("error")),
                          content: Text(tr("error_document")),
                        )
                      );
                    }else{
                      //Update user on db
                      if(mounted){
                        context.read<AuthProvider>().updateUserWithDocumentReference(resCV!, resLaurea!);
                        widget.goNext();
                      }
                    }
                  },
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
                      tr("save_document"),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => widget.goNext(),
                        child: Text(
                          tr("enter_later"),
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
