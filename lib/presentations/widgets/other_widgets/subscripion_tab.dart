// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class SubscriptionSingleButton extends StatelessWidget {
//   const SubscriptionSingleButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 400,
//       width: MediaQuery.of(context).size.width / 4,
//       decoration: BoxDecoration(
//           color: colorContainer,
//           borderRadius: BorderRadius.circular(10),
//           image: (currentSelected == 1)
//               ? DecorationImage(image: imgContainer, fit: BoxFit.cover)
//               : null,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1.5,
//               blurRadius: 2,
//               offset: const Offset(0, 3),
//             ),
//           ]),
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//                 height: 65,
//                 width: 50,
//                 child: Image.asset("lib/resources/images/logosanity.png")),
//             Text(
//               itemPricing[0].pricingTitle,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 26,
//                   color: (currentSelected == 1) ? Colors.white : Colors.black),
//             ),
//             Padding(
//                 padding:
//                     const EdgeInsets.only(bottom: 30, left: 40, right: 40.0),
//                 child: Center(
//                   child: Text(
//                     itemPricing[0].description,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: sizingInformation.deviceScreenType ==
//                                 DeviceScreenType.tablet
//                             ? 14
//                             : 17,
//                         color: (currentSelected == 1)
//                             ? Colors.white
//                             : Colors.black),
//                   ),
//                 )),
//             Padding(
//               padding: const EdgeInsets.only(top: 30.0, bottom: 15),
//               child: ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(
//                           const Color.fromARGB(255, 168, 140, 246))),
//                   onPressed: () {
//                     setState(() {
//                       currentSelected = 1;
//                     });
//                   },
//                   child: Text(
//                     tr("subscribe").toUpperCase(),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: sizingInformation.deviceScreenType ==
//                                 DeviceScreenType.tablet
//                             ? 9
//                             : 13),
//                   )),
//             )
//           ]),
//     );
//   }
// }
