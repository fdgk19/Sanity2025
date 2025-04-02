import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/search_container_desktop.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/search_container_mobile.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';

class ResearchScreen extends StatefulWidget {
  const ResearchScreen({super.key});

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> searchResult = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserListProvider>().search();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: sizingInformation.deviceScreenType ==
                              DeviceScreenType.mobile
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(70.0),
                      child: sizingInformation.deviceScreenType ==
                              DeviceScreenType.desktop
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Text(
                                        tr("search_pro"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40),
                                      ),
                                       Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, bottom: 20),
                                        child: Text(
                                          tr("start_research"),
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              width: 15,
                                              height: 15,
                                              color: Colors.green,
                                              "lib/resources/images/certificate.svg"),
                                           Text(
                                            tr("name_surname"),
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                width: 15,
                                                height: 15,
                                                color: Colors.green,
                                                "lib/resources/images/certificate.svg"),
                                             Text(
                                              tr("profession"),
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: const SearchContainerDesktop()),
                              ],
                            )
                          : const SearchContainerMobile())
                ],
              ),
            ));
}
}
