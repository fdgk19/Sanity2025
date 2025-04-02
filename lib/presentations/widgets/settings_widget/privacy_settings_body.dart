import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/settings_single_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration:   BoxDecoration(
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
                  child: Text(tr("Privacy"), style:const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                ),
               Padding(
                 padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                 child: SingleSettingTab(
                  text:(tr("info_privacy")),
                  onButtonPress: () {launchURL('https://www.iubenda.com/privacy-policy/90601080'); },
                ),
               ),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Container(
                decoration:   BoxDecoration(
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
                    child: Text(tr("Privacy"), style:const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                  ),
                 Padding(
                   padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                   child: SingleSettingTab(
                    text:(tr("terms_and_conditions")),
                    onButtonPress: () {launchURL('https://www.iubenda.com/termini-e-condizioni/90601080');  },
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
    void launchURL(String inUrl) async {
  final url = Uri.encodeFull(inUrl);
    await launchUrl(Uri.parse(url));
}
}