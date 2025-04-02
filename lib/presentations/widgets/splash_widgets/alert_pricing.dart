// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/data/models/pricing_model.dart';
import 'package:sanity_web/presentations/state_management/stripe_provider.dart';

List<PricingWidgetSub> itemPricing = [
  PricingWidgetSub(
      pricingTitle: 'Sanity Free',
      description: tr("description_free")),
  PricingWidgetSub(
      pricingTitle: 'Sanity Pro',
      description: tr("description_pro")),
  PricingWidgetSub(
      pricingTitle: 'Sanity Angel',
      description: tr("description_angel")),
];

class PricingAlert extends StatefulWidget {
  final Function() goNext;

  const PricingAlert({
    Key? key,
    required this.goNext,
  }) : super(key: key);

  @override
  State<PricingAlert> createState() => _PricingAlertState();
}

class _PricingAlertState extends State<PricingAlert> {
  final Color colorContainer = const Color.fromARGB(255, 234, 234, 234);
  final AssetImage imgContainer =
      const AssetImage("lib/resources/images/background.png");
  bool reload = false;

  Future<void> redirectToCkecoutSession(
      BuildContext context, String priceId, bool applyCoupon) async {
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

  @override
  Widget build(BuildContext context) {
    return reload
        ? Center(
            heightFactor: 10.0,
            child: LoadingAnimationWidget.beat(
              color: const Color.fromARGB(255, 255, 177, 59),
              size: 20,
            ),
          )
        : ResponsiveBuilder(
            builder: (context, sizingInformation) => SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      sizingInformation.deviceScreenType ==
                              DeviceScreenType.mobile

                          //container  mobile

                          ? Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 0, right: 0, bottom: 30),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 300,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: colorContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                            Text(
                                              itemPricing[0].pricingTitle,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: Colors.black),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20,
                                                  left: 40,
                                                  right: 40.0),
                                              child: Center(
                                                  child: Text(
                                                itemPricing[0].description,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                  onPressed: () {
                                                    widget.goNext();
                                                  },
                                                  child: Text(
                                                    tr("subscribe")
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            )
                                          ]),
                                    ),

                                    //secondo container mobile

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 50.0, bottom: 50),
                                      child: Container(
                                          height: 300,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: colorContainer,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1.5,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    itemPricing[1].pricingTitle,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15,
                                                              left: 40,
                                                              right: 40.0),
                                                      child: Center(
                                                        child: Text(
                                                          itemPricing[1]
                                                              .description,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      )),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              tr("pricing_m"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0,
                                                                      bottom:
                                                                          15),
                                                              child:
                                                                  ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(
                                                                  const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      168,
                                                                      140,
                                                                      246),
                                                                )),
                                                                onPressed:
                                                                    () async {
                                                                  //TODO: checkout con mensile
                                                                  redirectToCkecoutSession(
                                                                      context,
                                                                      "price_1LvFvwH2TBDkZIx5FmXLXdKw", false);
                                                                },
                                                                child: Text(
                                                                  tr("subscribe")
                                                                      .toUpperCase(),
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Column(
                                                              children: [
                                                                Text(tr("pricing_y"),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black)),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0,
                                                                      bottom:
                                                                          15),
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(
                                                                      const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          168,
                                                                          140,
                                                                          246),
                                                                    )),
                                                                    onPressed:
                                                                        () async {
                                                                      //TODO: checkout con annuale
                                                                      redirectToCkecoutSession(
                                                                          context,
                                                                          "price_1Lv2yAH2TBDkZIx5zVWqxeYj", true);
                                                                    },
                                                                    child: Text(
                                                                      tr("subscribe")
                                                                          .toUpperCase(),
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ]),
                                                ]),
                                          )),
                                    ),
                                  ]),
                            )

                          //container web - tablet

                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxHeight: 220,
                                        minHeight: 220,
                                        maxWidth: 300,
                                        minWidth: 200,
                                      ),
                                      decoration: BoxDecoration(
                                          color: colorContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1.5,
                                              blurRadius: 2,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  itemPricing[0].pricingTitle,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15,
                                                          left: 40,
                                                          right: 40.0),
                                                  child: Center(
                                                    child: Text(
                                                      itemPricing[0]
                                                          .description,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
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
                                                  onPressed: () {
                                                    widget.goNext();
                                                  },
                                                  child: Text(
                                                    tr("subscribe")
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11),
                                                  ))
                                            ]),
                                      ),
                                    ),
                                  ),

                                  // secondo container web - tablet

                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxHeight: 240,
                                        minHeight: 240,
                                        maxWidth: 300,
                                        minWidth: 200,
                                      ),
                                      decoration: BoxDecoration(
                                          color: colorContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1.5,
                                              blurRadius: 2,
                                              offset: const Offset(0, 3),
                                            )
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding: sizingInformation
                                                              .deviceScreenType ==
                                                          DeviceScreenType
                                                              .tablet
                                                      ? const EdgeInsets.all(
                                                          10.0)
                                                      : const EdgeInsets.all(
                                                          10.0),
                                                  child: Text(
                                                    itemPricing[1].pricingTitle,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  )),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          left: 40,
                                                          right: 40.0),
                                                  child: Text(
                                                    itemPricing[1].description,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          tr("pricing_m"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  168,
                                                                  140,
                                                                  246),
                                                            )),
                                                            onPressed:
                                                                () async {
                                                              //TODO: checkout con mensile
                                                              redirectToCkecoutSession(
                                                                  context,
                                                                  "price_1LvFvwH2TBDkZIx5FmXLXdKw", false);
                                                            },
                                                            child: Text(
                                                              tr("subscribe")
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 11),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(tr("pricing_y"),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            )),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  168,
                                                                  140,
                                                                  246),
                                                            )),
                                                            onPressed:
                                                                () async {
                                                              //TODO: checkout con annuale
                                                              redirectToCkecoutSession(
                                                                  context,
                                                                  "price_1Lv2yAH2TBDkZIx5zVWqxeYj", true);
                                                            },
                                                            child: Text(
                                                              tr("subscribe")
                                                                  .toUpperCase(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 11),
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
                                  ),
                                ],
                              ),
                            ),
                    ])));
  }
}
