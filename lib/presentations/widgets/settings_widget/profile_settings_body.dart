import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/commons/utils.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/settings_single_tab.dart';
// ignore: unused_import
import 'package:universal_html/html.dart' as html;


class ProfileSettings extends StatefulWidget {
  final UserModel currentUser;
  final Function() needRebuild;
  const ProfileSettings({super.key, required this.currentUser, required this.needRebuild});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) =>  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget.currentUser.isDoctor
            ? Container(
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey, width: 0.3)
                ),
                width: sizingInformation.deviceScreenType != DeviceScreenType.mobile
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10),
                    child: Text(tr("document"), style:const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SingleSettingTab(
                    text:(tr("update_CV")), 
                    onButtonPress: () async { 
                      var file = await fileFromStorage(documentExtSupported);
                       if (file == null && mounted) {
                          showerrortoast(tr("error_dimension"),context);
                        }
                      if(file != null && mounted){
                        var resCV = await Provider.of<AuthProvider>(context, listen: false).uploadFile(file, "cv");
                        if(resCV == null){
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
                            context.read<AuthProvider>().updateUserWithDocumentReference(resCV, "");
                            context.read<AuthProvider>().fetchUser();
                          }
                        }
                      }else{
                        await showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: Text(tr("error")),
                          content: Text(tr("error_document")),
                        )
                      );  
                      }
                     },
                    ),
                ),
                const Divider(thickness: 0.6),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: SingleSettingTab(
                    text:(tr("update_degree")), 
                    onButtonPress: () async { 
                      var file = await fileFromStorage(documentExtSupported);
                       if (file == null && mounted) {
                          showerrortoast(tr("error_dimension"),context);
                        }
                      if(file != null && mounted){
                        var resDegree = await Provider.of<AuthProvider>(context, listen: false).uploadFile(file, "degree");
                        if(resDegree == null){
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
                            context.read<AuthProvider>().updateUserWithDocumentReference("", resDegree);
                            context.read<AuthProvider>().fetchUser();
                          }
                        }
                      }else{
                        await showDialog(
                        context: context, 
                        builder: (context) => AlertDialog(
                          title: Text(tr("error")),
                          content: Text(tr("error_document")),
                        )
                      );  
                      }
                     },
                  ),
                ),
                ],),
              )
            : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Container(
                width:sizingInformation.deviceScreenType != DeviceScreenType.mobile
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width * 0.9,
                 decoration:   BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.grey, width: 0.3)
              ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10 ),
                    child: Text(tr("language"), style:const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                  ),
                 Padding(
                   padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                   child: LanguageSettingTab(
                      text:(tr("change_language")), 
                      needRebuild: () async{
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                          return AlertDialog(
                            content: Container(
                              color: Colors.white,
                               child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:14),
                                    child: Text(tr("need_reload")),
                                  ),
                                  MaterialButton(
                                    onPressed: () => AutoRouter.of(context).push(const MainRoute()),
                                    color: Colors.blue,
                                    child: const Text("Ok", style: TextStyle(color: Colors.white),))
                                ])),
                          );
                        },
                        );
              
                        // html.window.alert("_reload");
                        // html.window.onMessage.listen((event) {
                        //   var data = event.data;
                        //   print(data);
                        // });

                        // html.window.onClick.listen((event) {
                        // print(data);
                        // });
                        
                        setState(() {});
                        widget.needRebuild();
                      }
                    ),
                 ),
                
                ],),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}