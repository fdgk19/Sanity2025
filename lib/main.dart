import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sanity_web/commons/custom_asset_loader.dart';
import 'package:sanity_web/commons/custom_scroll_behavior.dart';
import 'package:sanity_web/commons/locator.dart';
import 'package:sanity_web/commons/providers.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupDi();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('it', 'IT'), Locale('en', 'US')],
    path: 'lib/resources/locale',
    assetLoader: const CustomAssetLoader(),
    fallbackLocale: const Locale('it', 'IT'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final router = locator<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providerList,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        scrollBehavior: MyCustomScrollBehavior(),
        routerDelegate: router.delegate(),
        routeInformationParser: router.defaultRouteParser(),
      ),
    );
  }
}
