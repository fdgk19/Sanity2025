import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ChooseContent extends StatelessWidget {
  final String image;
  final IconData icon;
  final String buttonText;
  final String description;
  final Function() onChoose;
  final bool forceDraft;
  final bool checkInProgress;
  const ChooseContent(
      {Key? key,
      required this.image,
      required this.icon,
      required this.buttonText,
      required this.description,
      required this.onChoose, 
      required this.forceDraft,
      required this.checkInProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "lib/resources/images/background.png",
                ),
                fit: BoxFit.fill),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        constraints: BoxConstraints(
            maxHeight: sizingInformation.deviceScreenType ==
                        DeviceScreenType.desktop ||
                    sizingInformation.deviceScreenType ==
                        DeviceScreenType.tablet
                ? 380
                : 300,
            maxWidth: 300,
            minHeight: 70,
            minWidth: 70),
        child: checkInProgress
        ? Center(
            heightFactor: 10.0,
            child: LoadingAnimationWidget.beat(
              color: const Color.fromARGB(255, 255, 177, 59),
              size: 20,
            ),
          )
        : Stack(
          alignment: Alignment.center,
          children: [
            AbsorbPointer(
              absorbing: forceDraft,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: forceDraft ? 0 : 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: sizingInformation.deviceScreenType ==
                                  DeviceScreenType.desktop ||
                              sizingInformation.deviceScreenType ==
                                  DeviceScreenType.tablet
                          ? 280
                          : 220,
                      child: Image.asset(
                        image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => onChoose(),
                        child: Container(
                          height: 30,
                          width: 175,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                icon,
                                color: Colors.white,
                              ),
                              DefaultTextStyle(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12),
                                child: Text(
                                  buttonText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 60, left: 60),
                      child: DefaultTextStyle(
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer()
                  ],
                ),
              ),
            ),
            Visibility(
                visible: forceDraft,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: forceDraft ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DefaultTextStyle(
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        child: Text(
                          tr("no_create_post_title"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DefaultTextStyle(
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,),
                        child: Text(
                          tr("no_create_post_body"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        )
      );
    });
  }
}
