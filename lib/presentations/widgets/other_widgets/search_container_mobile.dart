import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/search_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchContainerMobile extends StatefulWidget {
  const SearchContainerMobile({super.key});

  @override
  State<SearchContainerMobile> createState() => _SearchContainerMobileState();
}

class _SearchContainerMobileState extends State<SearchContainerMobile> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> searchResult = [];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Container(
          height: sizingInformation.deviceScreenType == DeviceScreenType.tablet
              ? 450
              : MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 0.6,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  sizingInformation.deviceScreenType == DeviceScreenType.tablet
                      ? const BorderRadius.all(Radius.circular(8))
                      : const BorderRadius.all(Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      width: 750,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextField(
                          onSubmitted: (value) {
                            setState(() {});
                            context.read<UserListProvider>().search();
                          },
                          cursorColor: Colors.black,
                          style: const TextStyle(fontSize: 18),
                          controller: searchController,
                          decoration: InputDecoration(
                              prefixIcon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: IconButton(
                                      onPressed: () => {},
                                      icon: const Icon(
                                        Icons.search,
                                        size: 30,
                                      ))),
                              border: InputBorder.none,
                              hintText: tr("search")),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            searchController.text.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 20, top: 80),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Text (tr("search_pro"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Text(tr("start_research"),
                              style:const TextStyle(fontSize: 18),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    width: 13,
                                    height: 13,
                                    color: Colors.green,
                                    "lib/resources/images/certificate.svg"),
                                 Text(tr("name_surname"),
                                  style:const TextStyle(fontSize: 15),
                                )
                              ]),Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        width: 13,
                                        height: 13,
                                        color: Colors.green,
                                        "lib/resources/images/certificate.svg"),
                                     Text(tr("profession"),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                                      
                        ]))
                : Flexible(
                    child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Consumer<UserListProvider>(
                              builder: (context, value, child) {
                            searchResult.clear();
                            if (value.loading) {
                               return Center(
                                  child: LoadingAnimationWidget.beat(
                                color: const Color.fromARGB(255, 255, 177, 59),
                                size: 60,
                              ));
                            } else {
                              if (value.userSearched != null) {
                                for (var element in value.userSearched!) {
                                  if (searchController.text.isNotEmpty) {
                                    if (element.name.toLowerCase().contains(
                                            searchController.text
                                                .toLowerCase()) ||
                                        element.surname.toLowerCase().contains(
                                            searchController.text
                                                .toLowerCase()) ||
                                        element.mainProfesion!
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase())) {
                                      searchResult.add(element);
                                    }
                                  }
                                }
                              }
                              if (searchResult.isEmpty) {
                                return const SizedBox.shrink();
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: searchResult.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20.0),
                                          child: GestureDetector(
                                            onTap: () =>AutoRouter.of(context).push(ProfileDetailRoute( uid: searchResult[index].uid)),
                                            child: SearchItem(
                                                name: searchResult[index].name,
                                                image:searchResult[index].photoUrl,
                                                isPro:searchResult[index].isPremium,
                                                mainProfession:searchResult[index].mainProfesion ?? "",
                                                surname:
                                                    searchResult[index].surname),
                                          ));
                                    });
                              }
                            }
                          }),
                        ]))))
          ])),
    );
  }
}
