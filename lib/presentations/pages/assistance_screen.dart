import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/widgets/footer.dart/footer_desktop.dart';
import 'package:url_launcher/url_launcher.dart';

class AssistanceScreen extends StatelessWidget {
  const AssistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 50, 30),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.grey, width: 0.3)),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tr("contacts"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            children: [
                              Text(tr("contact_number"),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                              const Text("+39 351 5107601",
                                  style:  TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(tr("Email"),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                Text(tr("service_mail"),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal)),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {launchURL();},
                                    child: const Text("Sanity.digital.health@gmail.com", 
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.underline)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 111, 83, 224),
                              Color.fromARGB(255, 50, 140, 162),
                              Color.fromARGB(255, 20, 182, 100)
                            ])),
                        width: 400,
                        height: 270,
                        child: Center(
                            child: Image.asset(
                          "lib/resources/images/logosanity.png",
                          width: 200,
                          height: 150,
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 130.0),
              child: FooterDesktop(),
            ),
            sizingInformation.deviceScreenType == DeviceScreenType.tablet ||
                    sizingInformation.deviceScreenType ==
                        DeviceScreenType.mobile
                ? const SizedBox(height: 150)
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }


   void launchURL() async {
  final url = Uri.encodeFull('mailto:sanity.digital.health@gmail.com');
    await launchUrl(Uri.parse(url));
}

}
