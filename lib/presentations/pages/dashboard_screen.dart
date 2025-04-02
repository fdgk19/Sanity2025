// import 'package:easy_localization/easy_localization.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:flutter/material.dart';
// import 'package:sanity_web/presentations/widgets/post_card.dart';
// import 'package:sanity_web/data/models/post_model.dart';

// List<PostModel> post = [
//     PostModel(
//       date: DateTime.now(),
//       mainImage: "lib/resources/images/background.png",
//       doctorId: '',
//       isPrivate: true,
//       isPublished: true,
//       mainTitle: '',
//       pid: '',
//       isFromPro: true,
//       section: [],
//     ),
//     PostModel(
//       date: DateTime.now(),
//       mainImage: "lib/resources/images/background.png",
//       doctorId: '',
//       isPrivate: true,
//       isPublished: true,
//       mainTitle: '',
//       pid: '',
//       isFromPro: true,
//       section: [],
//     ),
//     PostModel(
//       date: DateTime.now(),
//       mainImage: "lib/resources/images/background.png",
//       doctorId: '',
//       isPrivate: true,
//       isPublished: true,
//       mainTitle: '',
//       pid: '',
//       isFromPro: true,
//       section: [],
//     ),
//     PostModel(
//       date: DateTime.now(),
//       mainImage: "lib/resources/images/background.png",
//       doctorId: '',
//       isPrivate: true,
//       isPublished: true,
//       mainTitle: '',
//       pid: '',
//       isFromPro: true,
//       section: [],
//     ),
//     PostModel(
//       date: DateTime.now(),
//       mainImage: "lib/resources/images/background.png",
//       doctorId: '',
//       isPrivate: true,
//       isPublished: true,
//       mainTitle: '',
//       pid: '',
//       isFromPro: true,
//       section: [],
//     ),
// ];

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveBuilder(
//         builder: (context, sizingInformation) => SingleChildScrollView(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         sizingInformation.deviceScreenType ==
//                                 DeviceScreenType.mobile

//                             // mobile
//                             ? SizedBox(
//                                 width: MediaQuery.of(context).size.width,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(20.0),
//                                   child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               bottom: 20.0),
//                                           child: Text(
//                                             "La tua dashboard",
//                                             style: GoogleFonts.lato(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 25),
//                                           ),
//                                         ),
//                                         Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 220,
//                                           decoration: BoxDecoration(
//                                               color: const Color.fromARGB(
//                                                   255, 234, 234, 234),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.5),
//                                                   spreadRadius: 1.5,
//                                                   blurRadius: 2,
//                                                   offset: const Offset(0, 3),
//                                                 ),
//                                               ]),
//                                         ),
//                                         Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 20, bottom: 20),
//                                             child: Container(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width,
//                                               height: 140,
//                                               decoration: BoxDecoration(
//                                                   color: const Color.fromARGB(
//                                                       255, 234, 234, 234),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.grey
//                                                           .withOpacity(0.5),
//                                                       spreadRadius: 1.5,
//                                                       blurRadius: 2,
//                                                       offset:
//                                                           const Offset(0, 3),
//                                                     ),
//                                                   ]),
//                                               child: Align(
//                                                 alignment:
//                                                     Alignment.bottomCenter,
//                                                 child: SizedBox(
//                                                     width: 400,
//                                                     height: 180,
//                                                     child: Column(children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 14),
//                                                         child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Text(
//                                                                 "DR. Guido Mazzaro",
//                                                                 style: GoogleFonts.lato(
//                                                                     fontSize:
//                                                                         20,
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ]),
//                                                       ),
//                                                       Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .only(top: 2),
//                                                           child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                               children: [
//                                                                 Text(
//                                                                   "Rozzano, Milano",
//                                                                   style: GoogleFonts.lato(
//                                                                       fontSize:
//                                                                           13,
//                                                                       color: const Color
//                                                                               .fromARGB(
//                                                                           255,
//                                                                           167,
//                                                                           167,
//                                                                           167),
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                               ])),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .fromLTRB(
//                                                                 30, 20, 30, 10),
//                                                         child: Container(
//                                                           height: 50,
//                                                           decoration: const BoxDecoration(
//                                                               color:
//                                                                   Colors.white,
//                                                               borderRadius: BorderRadius
//                                                                   .all(Radius
//                                                                       .circular(
//                                                                           10))),
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .symmetric(
//                                                                     horizontal:
//                                                                         15),
//                                                             child: Row(
//                                                                 mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceBetween,
//                                                                 children: [
//                                                                   Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: const [
//                                                                         Text(
//                                                                           "109",
//                                                                           style: TextStyle(
//                                                                               color: Colors.black,
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 16,
//                                                                               fontWeight: FontWeight.bold),
//                                                                         ),
//                                                                         Text(
//                                                                           "Programmi",
//                                                                           style: TextStyle(
//                                                                               color: Color.fromARGB(255, 197, 197, 197),
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 13,
//                                                                               fontWeight: FontWeight.normal),
//                                                                         ),
//                                                                       ]),
//                                                                   Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: const [
//                                                                         Text(
//                                                                           "250",
//                                                                           style: TextStyle(
//                                                                               color: Colors.black,
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 16,
//                                                                               fontWeight: FontWeight.bold),
//                                                                         ),
//                                                                         Text(
//                                                                           "Articoli",
//                                                                           style: TextStyle(
//                                                                               color: Color.fromARGB(255, 197, 197, 197),
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 13,
//                                                                               fontWeight: FontWeight.normal),
//                                                                         ),
//                                                                       ]),
//                                                                   Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: const [
//                                                                         Text(
//                                                                           "13MILA",
//                                                                           style: TextStyle(
//                                                                               color: Colors.black,
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 16,
//                                                                               fontWeight: FontWeight.bold),
//                                                                         ),
//                                                                         Text(
//                                                                           "Followers",
//                                                                           style: TextStyle(
//                                                                               color: Color.fromARGB(255, 197, 197, 197),
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 13,
//                                                                               fontWeight: FontWeight.normal),
//                                                                         ),
//                                                                       ]),
//                                                                   Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: const [
//                                                                         Text(
//                                                                           " 70",
//                                                                           style: TextStyle(
//                                                                               color: Colors.black,
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 16,
//                                                                               fontWeight: FontWeight.bold),
//                                                                         ),
//                                                                         Text(
//                                                                           "Seguiti",
//                                                                           style: TextStyle(
//                                                                               color: Color.fromARGB(255, 197, 197, 197),
//                                                                               fontFamily: "PublicSansBlack",
//                                                                               fontSize: 13,
//                                                                               fontWeight: FontWeight.normal),
//                                                                         ),
//                                                                       ]),
//                                                                 ]),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ])),
//                                               ),
//                                             )),
//                                         Padding(
//                                             padding: const EdgeInsets.only(
//                                                 bottom: 20),
//                                             child: GestureDetector(
//                                               onTap: null,
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 height: 100,
//                                                 decoration: BoxDecoration(
//                                                     color: const Color.fromARGB(
//                                                         255, 234, 234, 234),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.grey
//                                                             .withOpacity(0.5),
//                                                         spreadRadius: 1.5,
//                                                         blurRadius: 2,
//                                                         offset:
//                                                             const Offset(0, 3),
//                                                       )
//                                                     ]),
//                                                 child: Center(
//                                                   child: Text(
//                                                     "Ultimi appuntamenti",
//                                                     style: GoogleFonts.lato(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         fontSize: 20),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )),
//                                       ]),
//                                 ),
//                               )
// //
//                             //----------WEB - TABLET----------
// //
//                             : Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 20.0, left: 80, right: 0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "La tua dashboard",
//                                             style: GoogleFonts.lato(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 25),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 430,
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(15.0),
//                                                 child: Container(
//                                                   width: sizingInformation
//                                                               .deviceScreenType ==
//                                                           DeviceScreenType
//                                                               .tablet
//                                                       ? 300
//                                                       : MediaQuery.of(context)
//                                                               .size
//                                                               .width /
//                                                           2.2,
//                                                   height: sizingInformation
//                                                               .deviceScreenType ==
//                                                           DeviceScreenType
//                                                               .tablet
//                                                       ? 360
//                                                       : 400,
//                                                   decoration: BoxDecoration(
//                                                       color:
//                                                           const Color.fromARGB(
//                                                               255,
//                                                               234,
//                                                               234,
//                                                               234),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       boxShadow: [
//                                                         BoxShadow(
//                                                           color: Colors.grey
//                                                               .withOpacity(0.5),
//                                                           spreadRadius: 1.5,
//                                                           blurRadius: 2,
//                                                           offset: const Offset(
//                                                               0, 3),
//                                                         )
//                                                       ]),
//                                                 )),
//                                             SizedBox(
//                                               width: sizingInformation
//                                                           .deviceScreenType ==
//                                                       DeviceScreenType.tablet
//                                                   ? 250
//                                                   : 430,
//                                               height: sizingInformation
//                                                           .deviceScreenType ==
//                                                       DeviceScreenType.tablet
//                                                   ? 390
//                                                   : 430,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 15,
//                                                     right: 12,
//                                                     left: 16,
//                                                     bottom: 15),
//                                                 child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Container(
//                                                           width: sizingInformation
//                                                                       .deviceScreenType ==
//                                                                   DeviceScreenType
//                                                                       .tablet
//                                                               ? 310
//                                                               : MediaQuery.of(context)
//                                                                       .size
//                                                                       .width /
//                                                                   3,
//                                                           height: sizingInformation
//                                                                       .deviceScreenType ==
//                                                                   DeviceScreenType
//                                                                       .tablet
//                                                               ? 200
//                                                               : 220,
//                                                           decoration: BoxDecoration(
//                                                               color: const Color
//                                                                       .fromARGB(
//                                                                   255,
//                                                                   234,
//                                                                   234,
//                                                                   234),
//                                                               borderRadius:
//                                                                   BorderRadius.circular(10),
//                                                               boxShadow: [
//                                                                 BoxShadow(
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .withOpacity(
//                                                                           0.5),
//                                                                   spreadRadius:
//                                                                       1.5,
//                                                                   blurRadius: 2,
//                                                                   offset:
//                                                                       const Offset(
//                                                                           0, 3),
//                                                                 ),
//                                                               ]),
//                                                           child: Align(
//                                                               alignment: Alignment.bottomCenter,
//                                                               child: SizedBox(
//                                                                 width: 400,
//                                                                 height: 180,
//                                                                 child: Column(
//                                                                     children: [
//                                                                       Center(
//                                                                         child: Row(
//                                                                             mainAxisAlignment:
//                                                                                 MainAxisAlignment.center,
//                                                                             children: [
//                                                                               Text(
//                                                                                 "DR. Guido Mazzaro",
//                                                                                 style: GoogleFonts.lato(fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold),
//                                                                               ),
//                                                                             ]),
//                                                                       ),
//                                                                       Center(
//                                                                         child: Row(
//                                                                             mainAxisAlignment:
//                                                                                 MainAxisAlignment.center,
//                                                                             children: [
//                                                                               Text(
//                                                                                 "Rozzano, Milano",
//                                                                                 style: GoogleFonts.lato(fontSize: 13, color: const Color.fromARGB(255, 167, 167, 167), fontWeight: FontWeight.bold),
//                                                                               ),
//                                                                             ]),
//                                                                       ),
//                                                                       sizingInformation.deviceScreenType ==
//                                                                               DeviceScreenType.desktop
//                                                                           ? Padding(
//                                                                               padding: const EdgeInsets.fromLTRB(13, 30, 13, 10),
//                                                                               child: Container(
//                                                                                 height: 60,
//                                                                                 decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
//                                                                                 child: Padding(
//                                                                                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                                                                                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                                                                                     Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                       Text(
//                                                                                         "109",
//                                                                                         style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                       ),
//                                                                                       Text(
//                                                                                        tr('programs'),
//                                                                                         style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                       ),
//                                                                                     ]),
//                                                                                     Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                       Text(
//                                                                                         "250",
//                                                                                         style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                       ),
//                                                                                       Text(
//                                                                                         "Articoli",
//                                                                                         style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                       ),
//                                                                                     ]),
//                                                                                     Column(
//                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                       mainAxisAlignment: MainAxisAlignment.center,
//                                                                                       children: [
//                                                                                         Text(
//                                                                                           "13MILA",
//                                                                                           style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                         ),
//                                                                                         Text(
//                                                                                           "Followers",
//                                                                                           style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                     Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                       Text(
//                                                                                         " 70",
//                                                                                         style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                       ),
//                                                                                       Text(
//                                                                                         "Seguiti",
//                                                                                         style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                       ),
//                                                                                     ]),
//                                                                                   ]),
//                                                                                 ),
//                                                                               ))
//                                                                           : Padding(
//                                                                               padding: const EdgeInsets.fromLTRB(13, 30, 13, 10),
//                                                                               child: Container(
//                                                                                 height: 100,
//                                                                                 decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
//                                                                                 child: Column(
//                                                                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                                                   children: [
//                                                                                     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                       Padding(
//                                                                                         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//                                                                                         child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                           Text(
//                                                                                             "109",
//                                                                                             style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                           ),
//                                                                                           Text(
//                                                                                             "Programmi",
//                                                                                             style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                           ),
//                                                                                         ]),
//                                                                                       ),
//                                                                                       Padding(
//                                                                                         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//                                                                                         child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                           Text(
//                                                                                             "250",
//                                                                                             style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                           ),
//                                                                                           Text(
//                                                                                             "Articoli",
//                                                                                             style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                           ),
//                                                                                         ]),
//                                                                                       ),
//                                                                                     ]),
//                                                                                     Padding(
//                                                                                       padding: const EdgeInsets.all(8.0),
//                                                                                       child: Row(
//                                                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                                                         children: [
//                                                                                           Padding(
//                                                                                             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//                                                                                             child: Column(
//                                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                                               children: [
//                                                                                                 Text(
//                                                                                                   "13MILA",
//                                                                                                   style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                                 ),
//                                                                                                 Text(
//                                                                                                   "Followers",
//                                                                                                   style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                                 ),
//                                                                                               ],
//                                                                                             ),
//                                                                                           ),
//                                                                                           Padding(
//                                                                                             padding: const EdgeInsets.all(8.0),
//                                                                                             child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
//                                                                                               Text(
//                                                                                                 " 70",
//                                                                                                 style: TextStyle(color: Colors.black, fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 14 : 17, fontWeight: FontWeight.bold),
//                                                                                               ),
//                                                                                               Text(
//                                                                                                 "Seguiti",
//                                                                                                 style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197), fontFamily: "PublicSansBlack", fontSize: sizingInformation.deviceScreenType == DeviceScreenType.tablet ? 9 : 12, fontWeight: FontWeight.normal),
//                                                                                               ),
//                                                                                             ]),
//                                                                                           ),
//                                                                                         ],
//                                                                                       ),
//                                                                                     )
//                                                                                   ],
//                                                                                 ),
//                                                                               )),
//                                                                     ]),
//                                                               ))),
//                                                       MouseRegion(
//                                                         cursor:
//                                                             SystemMouseCursors
//                                                                 .click,
//                                                         child: Container(
//                                                           width: sizingInformation
//                                                                       .deviceScreenType ==
//                                                                   DeviceScreenType
//                                                                       .tablet
//                                                               ? 310
//                                                               : MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width /
//                                                                   3,
//                                                           height: sizingInformation
//                                                                       .deviceScreenType ==
//                                                                   DeviceScreenType
//                                                                       .tablet
//                                                               ? 150
//                                                               : 160,
//                                                           decoration: BoxDecoration(
//                                                               color: const Color
//                                                                       .fromARGB(
//                                                                   255,
//                                                                   234,
//                                                                   234,
//                                                                   234),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               boxShadow: [
//                                                                 BoxShadow(
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .withOpacity(
//                                                                           0.5),
//                                                                   spreadRadius:
//                                                                       1.5,
//                                                                   blurRadius: 2,
//                                                                   offset:
//                                                                       const Offset(
//                                                                           0, 3),
//                                                                 ),
//                                                               ]),
//                                                           child: Center(
//                                                               child: Text(
//                                                             "Ultimi appuntamenti",
//                                                             style: GoogleFonts.lato(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 fontSize: 19),
//                                                           )),
//                                                         ),
//                                                       )
//                                                     ]),
//                                               ),
//                                             )
//                                           ]),
//                                     ),
//                                     //
//                                   ]),
//                         sizingInformation.deviceScreenType ==
//                                 DeviceScreenType.mobile
//                             ? Padding(
//                                 padding:
//                                     const EdgeInsets.only(top: 10.0, left: 20),
//                                 child: Text(
//                                   "I miei programmi",
//                                   style: GoogleFonts.lato(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 25),
//                                 ),
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 20.0, left: 80, right: 80),
//                                 child: Text(
//                                   "I miei programmi",
//                                   style: GoogleFonts.lato(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 25),
//                                 ),
//                               ),
//                         sizingInformation.deviceScreenType ==
//                                 DeviceScreenType.mobile
//                             ? Padding(
//                                 padding: const EdgeInsets.only(top: 5.0),
//                                 child: SizedBox(
//                                   width: 500,
//                                   height: 210,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         right: 20, left: 20),
//                                     child: ListView.builder(
//                                         controller: null,
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: post.length,
//                                         itemBuilder: (context, index) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 15, bottom: 15, right: 30),
//                                             child: GestureDetector(
//                                               onTap: () {},
//                                               child: PostCard(
//                                                   proName: post[index].doctorId,
//                                                   proWork: "fisioterapista",
//                                                   like: 2,
//                                                   isfavorite: true,
//                                                   date: post[index].date,
//                                                   fullDescription: "",
//                                                   image:
//                                                       "lib/resources/images/background.png",
//                                                   title: post[index].mainTitle,
//                                                   shortDescription: ""),
//                                             ),
//                                           );
//                                         }),
//                                   ),
//                                 ),
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 5.0, left: 80, right: 80),
//                                 child: SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.88,
//                                   height: 210,
//                                   child: ListView.builder(
//                                       controller: null,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: post.length,
//                                       itemBuilder: (context, index) {
//                                         return Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 15, bottom: 15, right: 30),
//                                           child: GestureDetector(
//                                             onTap: () {},
//                                             child: PostCard(
//                                                 proName: post[index].doctorId,
//                                                 proWork: "fisioterapista",
//                                                 like: 2,
//                                                 isfavorite: true,
//                                                 date: post[index].date,
//                                                 fullDescription: "",
//                                                 image:
//                                                     "lib/resources/images/background.png",
//                                                 title: post[index].mainTitle,
//                                                 shortDescription: ""),
//                                           ),
//                                         );
//                                       }),
//                                 ),
//                               )
//                       ]),
//                 ),
//               ),
//             ));
//   }
// }
