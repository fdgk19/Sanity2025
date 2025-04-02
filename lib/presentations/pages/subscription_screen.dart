// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/state_management/stripe_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool reload = false;
  final Color colorContainer = const Color.fromARGB(255, 234, 234, 234);
  final AssetImage imgContainer =
      const AssetImage("lib/resources/images/background.png");

  Future<bool> _checkSubStatus(BuildContext context) async {
    bool status =
        await context.read<StripeProvider>().checkSubscriptionStatus();
    return status;
  }

  Future<void> redirectToCkecoutSession(BuildContext context, String priceId, bool applyCoupon) async {
    setState(() {
      reload = true;
    });
    String checkoutUrl = "";
    await super.context.read<StripeProvider>().getCheckoutSession(priceId, applyCoupon);
    if (mounted) {
      checkoutUrl = super.context.read<StripeProvider>().checkout!.url ?? "";
    }
    html.window.open(checkoutUrl, "_self");
  }

  Future<void> cancelSubscription(BuildContext context) async {
    await showDialog<bool>(
      builder: (context) => AlertDialog(
        title: Text(
          tr("create_post_advice_title"),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 8, left: 12, right: 12),
        content: SizedBox(
            width: 120,
            height: 120,
            child: Center(
                child: Text(
              tr("delete_sub_body"),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 13),
            ))),
        actions: [
          MaterialButton(
            color: Colors.red,
            onPressed: () {
              AutoRouter.of(context).pop(false);
            },
            child: Text(
              tr("back"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              setState(() {
                reload = true;
              });
              AutoRouter.of(context).pop(true);
            },
            child: Text(
              tr("continue"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      context: super.context,
    ).then((value) async {
      if(value != null && value){
        await context.read<StripeProvider>().cancelSubscription();
        setState(() {
          reload = false;
        });
      }
    });
  }

  Widget _showLoaderScreen() {
    return Center(
      heightFactor: 10.0,
      child: LoadingAnimationWidget.beat(
        color: const Color.fromARGB(255, 255, 177, 59),
        size: 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return reload
        ? _showLoaderScreen()
        : ResponsiveBuilder(
            builder: (context, sizingInformation) => SingleChildScrollView(
              child: FutureBuilder(
                  future: _checkSubStatus(context),
                  builder: (context, snapshot) => !snapshot.hasData
                      ? _showLoaderScreen()
                      : snapshot.data!
                          ? sizingInformation.deviceScreenType ==
                                  DeviceScreenType.mobile
                              // mobile
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 50, right: 50, bottom: 30),
                                  child: Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: colorContainer,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: imgContainer,
                                            fit: BoxFit.cover),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1.5,
                                            blurRadius: 2,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 25,
                                              width: 35,
                                              child: Image.asset(
                                                  "lib/resources/images/logosanity.png")),
                                          const Text(
                                            'Sanity Pro',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Colors.white),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20,
                                                left: 40,
                                                right: 40.0),
                                            child: Center(
                                                child: Text(
                                              tr("description_pro"),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                168,
                                                                140,
                                                                246))),
                                                onPressed: () async {
                                                  await cancelSubscription(
                                                      context);

                                                },
                                                child: Text(
                                                  tr("unsubscribe")
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )),
                                          )
                                        ]),
                                  ),
                                )
                              // web - tablet
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxHeight: 440,
                                        minHeight: 440,
                                        maxWidth: 500,
                                        minWidth: 200,
                                      ),
                                      // height: 440,
                                      //width: MediaQuery.of(context).size.width / 5,
                                      decoration: BoxDecoration(
                                          color: colorContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: imgContainer,
                                              fit: BoxFit.cover),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1.5,
                                              blurRadius: 2,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.asset(
                                                    "lib/resources/images/logosanity.png")),
                                            const Text(
                                              'Sanity Pro',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 26,
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 35,
                                                    left: 40,
                                                    right: 40.0),
                                                child: Center(
                                                  child: Text(
                                                    tr("description_pro"),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                168,
                                                                140,
                                                                246))),
                                                onPressed: () async {
                                                  await cancelSubscription(
                                                      context);
                                                },
                                                child: Text(
                                                  tr("unsubscribe")
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                ))
                                          ]),
                                    ),
                                  ),
                                )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                  sizingInformation.deviceScreenType ==
                                          DeviceScreenType.mobile
                                      // mobile
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 30,
                                              left: 50,
                                              right: 50,
                                              bottom: 30),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 300,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      color: colorContainer,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: imgContainer,
                                                          fit: BoxFit.cover),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1.5,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 3),
                                                        ),
                                                      ]),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: 25,
                                                            width: 35,
                                                            child: Image.asset(
                                                                "lib/resources/images/logosanity.png")),
                                                        const Text(
                                                         'Sanity Free',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 20,
                                                                  left: 40,
                                                                  right: 40.0),
                                                          child: Center(
                                                              child: Text(
                                                            tr("description_free"),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                          )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          168,
                                                                          140,
                                                                          246))),
                                                              onPressed: () {},
                                                              child: Text(
                                                                tr("selected")
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                        )
                                                      ]),
                                                ),

                                                //secondo container mobile

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50.0,
                                                          bottom: 50),
                                                  child: Container(
                                                      height: 330,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          color: colorContainer,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 1.5,
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      0, 3),
                                                            ),
                                                          ]),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: SizedBox(
                                                                  height: 25,
                                                                  width: 35,
                                                                  child: Image
                                                                      .asset(
                                                                          "lib/resources/images/logosanity.png")),
                                                            ),
                                                            const Text(
                                                              'Sanity Pro',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            15,
                                                                        left:
                                                                            40,
                                                                        right:
                                                                            40.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    tr("description_pro"),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                )),
                                                            Column(children: [
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Text(
                                                                      tr("pricing_m"),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              15.0),
                                                                      child: Column(
                                                                          children: [
                                                                            Text(tr("pricing_y"),
                                                                                textAlign: TextAlign.center,
                                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Text(
                                                                              tr("pricing_desc"),
                                                                              style: const TextStyle(fontSize: 10, color: Colors.black),
                                                                            )
                                                                          ]),
                                                                    ),
                                                                  ]),
                                                            ]),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          30.0),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            168,
                                                                            140,
                                                                            246),
                                                                      )),
                                                                      onPressed: () async {
                                                                        //TODO: checkout con mensile
                                                                        redirectToCkecoutSession(context, "price_1LvFvwH2TBDkZIx5FmXLXdKw", false);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        tr("subscribe")
                                                                            .toUpperCase(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            168,
                                                                            140,
                                                                            246),
                                                                      )),
                                                                      onPressed:
                                                                          () async {
                                                                        //TODO: checkout con annuale
                                                                        redirectToCkecoutSession(context, "price_1Lv2yAH2TBDkZIx5zVWqxeYj", true);
                                                                      },
                                                                      child: Text(
                                                                          tr("subscribe")
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                    ),
                                                                  ]),
                                                            )
                                                          ])),
                                                ),
                                              ]),
                                        )
                                      // web - tablet
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Wrap(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                    maxHeight: 440,
                                                    minHeight: 440,
                                                    maxWidth: 500,
                                                    minWidth: 200,
                                                  ),
                                                  // height: 440,
                                                  //width: MediaQuery.of(context).size.width / 5,
                                                  decoration: BoxDecoration(
                                                      color: colorContainer,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: imgContainer,
                                                          fit: BoxFit.cover),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1.5,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 3),
                                                        ),
                                                      ]),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: 100,
                                                            width: 100,
                                                            child: Image.asset(
                                                                "lib/resources/images/logosanity.png")),
                                                        const Text(
                                                         'Sanity Free',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 26,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 35,
                                                                    left: 40,
                                                                    right:
                                                                        40.0),
                                                            child: Center(
                                                              child: Text(
                                                               tr("description_free"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                        ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            168,
                                                                            140,
                                                                            246))),
                                                            onPressed: () {},
                                                            child: Text(
                                                              tr("selected")
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13),
                                                            ))
                                                      ]),
                                                ),
                                              ),
                                              // secondo container web - tablet
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                    maxHeight: 440,
                                                    minHeight: 440,
                                                    maxWidth: 500,
                                                    minWidth: 200,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: colorContainer,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 1.5,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 3),
                                                        )
                                                      ]),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: SizedBox(
                                                              height: 100,
                                                              width: 100,
                                                              child: Image.asset(
                                                                  "lib/resources/images/logosanity.png")),
                                                        ),
                                                        Padding(
                                                            padding: sizingInformation
                                                                        .deviceScreenType ==
                                                                    DeviceScreenType
                                                                        .tablet
                                                                ? const EdgeInsets
                                                                    .all(10.0)
                                                                : const EdgeInsets
                                                                    .all(15.0),
                                                            child: const Text(
                                                             'Sanity Pro',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 26,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 30,
                                                                    left: 40,
                                                                    right:
                                                                        40.0),
                                                            child: Text(
                                                             tr("description_pro"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    tr("pricing_m"),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          17,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            168,
                                                                            140,
                                                                            246),
                                                                      )),
                                                                      onPressed:
                                                                          () async {
                                                                        //TODO: checkout con abbonamento mensile
                                                                        redirectToCkecoutSession(context, "price_1LvFvwH2TBDkZIx5FmXLXdKw", false);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        tr("subscribe")
                                                                            .toUpperCase(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 13),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                      tr(
                                                                          "pricing_y"),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17,
                                                                      )),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            168,
                                                                            140,
                                                                            246),
                                                                      )),
                                                                      onPressed:
                                                                          () async {
                                                                        //TODO: checkout con abbonamento annuale
                                                                        redirectToCkecoutSession(context, "price_1Lv2yAH2TBDkZIx5zVWqxeYj", true);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        tr("subscribe")
                                                                            .toUpperCase(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 13),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, top: 35, right: 0),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 1040,
                                        minWidth: 300,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tr("sanity_angel"),
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 26,
                                                  color: Colors.black),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18.0),
                                              child: Text(
                                                tr("Sanity_angel_desc"),
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18.0),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 168, 140, 246),
                                                  ),
                                                  onPressed: () {
                                                    launchURL();
                                                    },
                                                  child: Text(
                                                    tr("more_information"),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                ])),
            ),
          );
  }

  void launchURL() async {
  final url = Uri.encodeFull('mailto:sanity.digital.health@gmail.com');
    await launchUrl(Uri.parse(url));
}
}