import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';

class ReedemCodeScreen extends StatefulWidget {
  const ReedemCodeScreen({super.key});

  @override
  State<ReedemCodeScreen> createState() => _ReedemCodeScreenState();
}

class _ReedemCodeScreenState extends State<ReedemCodeScreen> {
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("lib/resources/images/code.svg",
                 width:  sizingInformation.deviceScreenType == DeviceScreenType.mobile ? 0 : sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 50 : 100,),
                SizedBox(
                  width: sizingInformation.deviceScreenType == DeviceScreenType.tablet
                  ?  MediaQuery.of(context).size.width * 0.4
                  : sizingInformation.deviceScreenType == DeviceScreenType.mobile
                  ? MediaQuery.of(context).size.width 
                  : MediaQuery.of(context).size.width * 0.5,
                  child:  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(tr("redeem_text")),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Container(
              decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 0.09)
              ),
              width: sizingInformation.deviceScreenType == DeviceScreenType.tablet
                  ?  MediaQuery.of(context).size.width * 0.4
                  : sizingInformation.deviceScreenType == DeviceScreenType.mobile
                  ? MediaQuery.of(context).size.width  * 0.77
                  : MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                controller: codeController,
                decoration:  InputDecoration(
                  label: Text(tr("redeem_textbox")),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 8, left: 10),
              ),
              onFieldSubmitted: (value) async {
                 if (value.isNotEmpty) {
                   var result = await context.read<PostListProvider>().getPostByCode(value);
                   if (result){
                    showSuccess();
                   } else {
                    showError();
                   }
                 }
                
              },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20),
            child: SizedBox(
               width: sizingInformation.deviceScreenType == DeviceScreenType.tablet
                  ?  MediaQuery.of(context).size.width * 0.4
                  : sizingInformation.deviceScreenType == DeviceScreenType.mobile
                  ? MediaQuery.of(context).size.width  * 0.77
                  : MediaQuery.of(context).size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: (() async {
                      if (codeController.text.isNotEmpty) {
                     var result = await context.read<PostListProvider>().getPostByCode(codeController.text);
                     if (result){
                      showSuccess();
                     } else {
                      showError();
                     }
                   }
                  }),
                    child: Text(tr("redeem_code"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),))
                ],
              ),
            ),
             )
        ],
      );
    });
  }

  void showSuccess() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0))),
            contentPadding: const EdgeInsets.only(top: 0.0),
            content: Container(
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("lib/resources/images/success.svg", color: Colors.green, width: 120,),
                    Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(tr("redeem_success")),
                  )
                ],
              ),
              ),
    ));
  }

    void showError() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0))),
            contentPadding: const EdgeInsets.only(top: 0.0),
            content: Container(
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("lib/resources/images/error.svg", color: Colors.red, width: 120,),
                   Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tr("redeem_failed")),
                    ),
                  )
                ],
              ),
              ),
    ));
  }
}