import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/presentations/pages/assistance_screen.dart';
import 'package:sanity_web/presentations/pages/subscription_screen.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/privacy_settings_body.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/profile_settings_body.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/security_and_access_settings_body.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/settings_horizontal_item.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/settings_item.dart';

import '../state_management/auth_provider.dart';
import '../widgets/settings_widget/reedem_code_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    var user = context.read<AuthProvider>().currentUser;
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Row(
        children: [
          sizingInformation.deviceScreenType != DeviceScreenType.mobile
              ? Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          right: BorderSide(color: Colors.black, width: 0.1))),
                  width: 310,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 17),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 1;
                                });
                              },
                              child: SettingItem(
                                icon: "lib/resources/images/person.svg",
                                text: tr(
                                  "setting_account",
                                ),
                                color: currentIndex == 1
                                    ? Colors.amber
                                    : Colors.black,
                              )),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 2;
                                });
                              },
                              child: SettingItem(
                                icon: "lib/resources/images/key.svg",
                                text: tr("security"),
                                color: currentIndex == 2
                                    ? Colors.amber
                                    : Colors.black,
                              )),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 3;
                                });
                              },
                              child: SettingItem(
                                icon: "lib/resources/images/shield.svg",
                                text: tr("privacy"),
                                color: currentIndex == 3
                                    ? Colors.amber
                                    : Colors.black,
                              )),
                        ),
                        user.isDoctor 
                        ? MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 4;
                                });
                              },
                              child: SettingItem(
                                icon: "lib/resources/images/payment.svg",
                                text: tr("subscriptions"),
                                color: currentIndex == 4
                                    ? Colors.amber
                                    : Colors.black,
                              )),
                        )
                        : const SizedBox.shrink(),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = 5;
                                });
                              },
                              child: SettingItem(
                                icon: "lib/resources/images/callcenter.svg",
                                text: tr("assistance"),
                                color: currentIndex == 5
                                    ? Colors.amber
                                    : Colors.black,
                              )),
                        ),
                         MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                               setState(() {
                                  currentIndex = 6;
                                });
                              },
                              child: SettingItem(
                                icon: "lib/resources/images/code.svg",
                                text: tr("redeem_code"),
                                color: currentIndex == 6
                                    ? Colors.amber
                                    : Colors.black,
                              )),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                context.read<AuthProvider>().signOut();
                              },
                              child: SettingItem(
                                icon: "lib/resources/images/logout.svg",
                                text: tr("logout"),
                                color: currentIndex == 7
                                    ? Colors.amber
                                    : Colors.red,
                              )),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(
            width: sizingInformation.deviceScreenType != DeviceScreenType.mobile
                ? MediaQuery.of(context).size.width - 310
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizingInformation.deviceScreenType == DeviceScreenType.mobile
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 40.0,
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentIndex = 1;
                                        });
                                      },
                                      child: SettingHorizontalItem(
                                        text: tr(
                                          "setting_account",
                                        ),
                                        color: currentIndex == 1
                                            ? Colors.amber
                                            : Colors.black,
                                      )),
                                     ),
                                
                                Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: PopupMenuButton<Setting>(
                                    padding: const EdgeInsets.all(0),
                                    icon: Text(tr("other"),  style:  const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                                    onSelected: (value) {
                                      if(value == Setting.security) {
                                        setState(() {
                                          currentIndex = 2;
                                        });
                                      } else if (value == Setting.privacy) {
                                        setState(() {
                                          currentIndex = 3;
                                        });
                                      } else if (value == Setting.code) {
                                        setState(() {
                                          currentIndex = 6;
                                        });
                                      } else if (value == Setting.subscription) {
                                        setState(() {
                                          currentIndex = 4;
                                        });
                                      } else if (value == Setting.assistance) {
                                        setState(() {
                                          currentIndex = 5;
                                        });
                                      }
                                    } ,
                                    itemBuilder: (context) => [
                                    _buildPopupMenuItem(tr("security"), Setting.security),
                                    _buildPopupMenuItem(tr("privacy"), Setting.privacy),
                                    _buildPopupMenuItem(tr("redeem_code"), Setting.code),
                                    _buildPopupMenuItem(tr("subscriptions"), Setting.subscription),
                                    _buildPopupMenuItem(tr("assistance"), Setting.assistance),
                                  ],),
                                )
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  currentIndex == 1
                      ? ProfileSettings(currentUser: user, needRebuild: () { setState(() {}); },)
                      : currentIndex == 2
                          ? const SecurityAndAccessSettings()
                          : currentIndex == 3
                              ? const PrivacySettings()
                              : currentIndex == 4
                                  ? const SubscriptionScreen()
                                  : currentIndex == 5
                                      ? const AssistanceScreen()
                                      : currentIndex == 6
                                      ? const ReedemCodeScreen()
                                      : const SizedBox.shrink(),
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
    PopupMenuItem<Setting> _buildPopupMenuItem(String title, Setting position) {
    return PopupMenuItem<Setting>(
      value: position,
      child: Column(
        children: [
          Text(title),
        ],
      ),
    );
  }
}
