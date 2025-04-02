import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/data/models/login_provider_result_model.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/login_alert.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/main_sign_up.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  bool showLogin = true;
  LoginProviderResultModel? providerResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
                 decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "lib/resources/images/background.png",
                      ),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
                constraints: const BoxConstraints(
                    maxHeight: 630,
                    maxWidth: 800,
                    minHeight: 70,
                    minWidth: 800),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Padding(
                             padding: const EdgeInsets.fromLTRB(10,15,10,10),
                             child: Row(
                              children: [
                                sizingInformation.deviceScreenType ==
                                        DeviceScreenType.mobile
                                    ? SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Image.asset(
                                            "lib/resources/images/logosanity.png"),
                                      )
                                    : const SizedBox(),
                                Text(
                                  showLogin ? "${tr("welcome_back")}!" : "${tr("welcome")}!",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                   ),
                                   
                                 ],
                                ),
                           ),
                           const Divider(color: Colors.white, thickness: 1.4,),
                           Padding(
                             padding: const EdgeInsets.only(top:20.0, bottom: 30,),
                             child: Wrap(
                              children: [
                                  sizingInformation.deviceScreenType == DeviceScreenType.mobile
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: 400,
                                          width: 400,
                                          child: Image.asset(
                                              "lib/resources/images/logosanity.png"),
                                        ),
                                  showLogin
                                  ? Padding(
                                    padding: sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                                      ? const EdgeInsets.symmetric(horizontal: 8) 
                                      :  const EdgeInsets.all(0),
                                    child: LogInAlert(
                                        switchBody: (providerLoginResult) {
                                          setState(() {
                                            providerResult = providerLoginResult;
                                            showLogin = !showLogin;
                                          });
                                        },
                                      ),
                                  )
                                  : Padding(
                                   padding: sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                                      ? const EdgeInsets.symmetric(horizontal: 8) 
                                      :  const EdgeInsets.all(0),
                                    child: MainSignUp(
                                      providerResult: providerResult,
                                        switchBody: () {
                                          setState(() {
                                            showLogin = !showLogin;
                                          });
                                        },
                                      ),
                                  )
                              ],),
                           ),  
                        ],
                      ),
                    )
                
                
               
          ))  );
  }
}
