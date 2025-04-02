import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanity_web/presentations/widgets/footer.dart/footer_social_item.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterDesktop extends StatelessWidget {
  const FooterDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(left: 18, top: 30, bottom: 70),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:3.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  minWidth: 150,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      constraints: const BoxConstraints(
                        maxWidth: 100,
                        minHeight: 20,
                        minWidth: 30,
                      ),
                        child:
                            Image.asset("lib/resources/images/sanitylogobg.png", fit: BoxFit.cover,)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Text(
                              tr("Cookie_Policy"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Text(" | ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18)),
                          GestureDetector(
                            onTap: () async {
                               final url = Uri.encodeFull('https://www.iubenda.com/privacy-policy/90601080');
                               await launchUrl(Uri.parse(url));
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                tr("Privacy_Policy"),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text("Sanity 2023",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  minWidth: 150,
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.0),
                      child: Text(
                        ("®SANITY HEALTH EMPOWERING S.R.L."),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        ("Via Ettore Bugatti 3"),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        ("20142 Milano (MI)"),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        ("P.IVA: 11618360967"),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: Text("email: Sanity.digital.health@gmail.com",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: Text("cell: +39 351 5107601",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 300,
                minWidth: 150,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      tr(
                        "follow_footer",
                      ),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: GestureDetector(
                            onTap: () async {
                            var url = "https://www.instagram.com/sanity.italia/";
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                            child: const FooterSocialItem(
                                icon: "lib/resources/images/instagram.svg"),
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: GestureDetector(
                            onTap: () async {
                            var url = "https://www.linkedin.com/company/sanity-italia/";
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                            child: const FooterSocialItem(
                                icon: "lib/resources/images/linkedin.svg"),
                          ),
                        ),
                        //  Padding(
                        //   padding: const EdgeInsets.only(right: 4.0),
                        //   child: GestureDetector(
                        //     onTap: () async {
                        //     var url = "https://devworld.it/";
                        //     if (await canLaunchUrl(Uri.parse(url))) {
                        //       await launchUrl(Uri.parse(url));
                        //     }
                        //   },
                        //     child: const FooterSocialItem(
                        //         icon: "lib/resources/images/facebook.svg"),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Powered by",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                       onTap: () async {
                            var url = "https://devworld.it/";
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0, bottom:0),
                        child: Image.asset(
                          "lib/resources/images/devworld.png",
                          width: 140,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
