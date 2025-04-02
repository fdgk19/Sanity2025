import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/data/models/pricing_model.dart';

List<PricingWidgetSub> itemPricing = [
  PricingWidgetSub(
      pricingTitle: 'Sanity Free',
      description:
          "Crea fino a 3 contenuti innovativi o bozze e fai l'upgrade successivamente quando ti senti pronta/o"),
  PricingWidgetSub(
      pricingTitle: 'Sanity Pro',
      description:
          "Abbonati a Sanity annualmente e utilizza illimitatamente la piattaforma innovativa Sanity. Puoi disdire se e quando vuoi"),
  PricingWidgetSub(
      pricingTitle: 'Sanity Angel',
      description:
          "Hai un'azienda con più professionisti, sei un professionista con idee innovative o hai un codice da inserire? Clicca qui!"),
];

class SignUpSubscriptionScreen extends StatefulWidget {
  const SignUpSubscriptionScreen({super.key});

  @override
  State<SignUpSubscriptionScreen> createState() => _SignUpSubscriptionScreenState();
}

class _SignUpSubscriptionScreenState extends State<SignUpSubscriptionScreen> {
  final Color colorContainer = const Color.fromARGB(255, 234, 234, 234);
  int currentSelected = 0;
  final AssetImage imgContainer =
      const AssetImage("lib/resources/images/background.png");

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  sizingInformation.deviceScreenType == DeviceScreenType.mobile

                      //primo container  mobile

                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 0, right: 0, bottom: 30),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: colorContainer,
                                      borderRadius: BorderRadius.circular(10),
                                      image: (currentSelected == 1)
                                          ? DecorationImage(
                                              image: imgContainer,
                                              fit: BoxFit.cover)
                                          : null,
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
                                        
                                        Text(
                                          itemPricing[0].pricingTitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: (currentSelected == 1)
                                                  ? Colors.white
                                                  : Colors.black),
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
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: (currentSelected == 1)
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                              255,
                                                              168,
                                                              140,
                                                              246))),
                                              onPressed: () {
                                                setState(() {
                                                  currentSelected = 1;
                                                });
                                              },
                                              child: Text(
                                                tr("subscribe").toUpperCase(),
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
                                      height: 400,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: colorContainer,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: (currentSelected == 2 ||
                                                  currentSelected == 3)
                                              ? DecorationImage(
                                                  image: imgContainer,
                                                  fit: BoxFit.cover)
                                              : null,
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
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                          
                                            Text(
                                              itemPricing[1].pricingTitle,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: (currentSelected ==
                                                              2 ||
                                                          currentSelected == 3)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15,
                                                    left: 40,
                                                    right: 40.0),
                                                child: Center(
                                                  child: Text(
                                                    itemPricing[1].description,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: (currentSelected ==
                                                                    2 ||
                                                                currentSelected ==
                                                                    3)
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                )),
                                            Column(children: [
                                              Text(
                                                tr("pricing_m"),
                                                textAlign:
                                                    TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: (currentSelected ==
                                                                2 ||
                                                            currentSelected ==
                                                                3)
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:8.0, bottom: 15),
                                                child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                          const Color.fromARGB(
                                                              255, 168, 140, 246),
                                                        )),
                                                        onPressed: () {
                                                          setState(() {
                                                            currentSelected = 2;
                                                          });
                                                        },
                                                        child: Text(
                                                          tr("subscribe")
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              
                                              Column(children: [
                                              Text(tr("pricing_y"),
                                                    textAlign: TextAlign
                                                        .center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight
                                                                .bold,
                                                        color: (currentSelected ==
                                                                    2 ||
                                                                currentSelected ==
                                                                    3)
                                                            ? Colors
                                                                .white
                                                            : Colors
                                                                .black)),
                                              const SizedBox(
                                                  height: 2,
                                                ),
                                              Text(
                                                  tr("pricing_desc"),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: (currentSelected ==
                                                                  2 ||
                                                              currentSelected ==
                                                                  3)
                                                          ? Colors.white
                                                          : Colors
                                                              .black),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:8.0),
                                                child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                          const Color.fromARGB(
                                                              255, 168, 140, 246),
                                                        )),
                                                        onPressed: () {
                                                          setState(() {
                                                            currentSelected = 3;
                                                          });
                                                        },
                                                        child: Text(
                                                            tr("subscribe")
                                                                .toUpperCase(),
                                                            style:
                                                                const TextStyle(
                                                              color: Colors.white,
                                                            )),
                                                      ),
                                              ),
                                           
                                              ]),
                                            ]),
                                           
                                          ])),
                                ),

                           

                              ]),
                        )

                      //  primo container web - tablet

                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                  // height: 440,
                                  //width: MediaQuery.of(context).size.width / 5,
                                  decoration: BoxDecoration(
                                      color: colorContainer,
                                      borderRadius: BorderRadius.circular(10),
                                      image: (currentSelected == 1)
                                          ? DecorationImage(
                                              image: imgContainer,
                                              fit: BoxFit.cover)
                                          : null,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1.5,
                                          blurRadius: 2,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:20.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              itemPricing[0].pricingTitle,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: (currentSelected == 1)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15,
                                                  left: 40,
                                                  right: 40.0),
                                              child: Center(
                                                child: Text(
                                                  itemPricing[0].description,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          (currentSelected == 1)
                                                              ? Colors.white
                                                              : Colors.black),
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
                                              onPressed: () async {
                                                setState(() {
                                                  currentSelected = 1;
                                                });
                                              },
                                              child: Text(
                                                tr("subscribe").toUpperCase(),
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
                                      borderRadius: BorderRadius.circular(10),
                                      image: (currentSelected == 2 ||
                                              currentSelected == 3)
                                          ? DecorationImage(
                                              image: imgContainer,
                                              fit: BoxFit.cover)
                                          : null,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1.5,
                                          blurRadius: 2,
                                          offset: const Offset(0, 3),
                                        )
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                         
                                          Padding(
                                              padding: sizingInformation
                                                          .deviceScreenType ==
                                                      DeviceScreenType.tablet
                                                  ? const EdgeInsets.all(10.0)
                                                  : const EdgeInsets.all(10.0),
                                              child: Text(
                                                itemPricing[1].pricingTitle,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: (currentSelected ==
                                                                2 ||
                                                            currentSelected == 3)
                                                        ? Colors.white
                                                        : Colors.black),
                                              )),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 40,
                                                  right: 40.0),
                                              child: Text(
                                                itemPricing[1].description,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: (currentSelected ==
                                                                2 ||
                                                            currentSelected == 3)
                                                        ? Colors.white
                                                        : Colors.black),
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      tr("pricing_m"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (currentSelected ==
                                                                    2 ||
                                                                currentSelected ==
                                                                    3)
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                          const Color.fromARGB(
                                                              255, 168, 140, 246),
                                                        )),
                                                        onPressed: () {
                                                          setState(() {
                                                            currentSelected = 2;
                                                          });
                                                        },
                                                        child: Text(
                                                          tr("subscribe")
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 11),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(tr("pricing_y"),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: (currentSelected ==
                                                                      2 ||
                                                                  currentSelected ==
                                                                      3)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(
                                                          const Color.fromARGB(
                                                              255, 168, 140, 246),
                                                        )),
                                                        onPressed: () {
                                                          setState(() {
                                                            currentSelected = 3;
                                                          });
                                                        },
                                                        child: Text(
                                                          tr("subscribe")
                                                              .toUpperCase(),
                                                          style: const TextStyle(
                                                              color: Colors.white,
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
                  //     const FooterDesktop(),
                ])));
  }
}
