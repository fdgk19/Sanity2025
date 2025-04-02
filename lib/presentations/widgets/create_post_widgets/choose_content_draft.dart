import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/draft_tile.dart';

class ChooseContentDraft extends StatefulWidget {
  final String image;
  final IconData icon;
  final String buttonText;
  final String description;
  final Function(String postId) onChoose;
  const ChooseContentDraft(
      {Key? key,
      required this.image,
      required this.icon,
      required this.buttonText,
      required this.description,
      required this.onChoose})
      : super(key: key);

  @override
  State<ChooseContentDraft> createState() => _ChooseContentDraftState();
}

class _ChooseContentDraftState extends State<ChooseContentDraft> {
  bool showDraft = false;

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(
                absorbing: showDraft,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showDraft ? 0 : 1,
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
                          widget.image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showDraft = true;
                            });
                          },
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
                                  widget.icon,
                                  color: Colors.white,
                                ),
                                DefaultTextStyle(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 12),
                                  child: Text(
                                    widget.buttonText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0, right:45, left:45),
                        child: DefaultTextStyle(
                          style:
                              const TextStyle(color: Colors.white, fontSize: 12),
                          child: Text(
                            widget.description,
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
                visible: showDraft,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showDraft ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DefaultTextStyle(
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        child: Text(
                          tr("draft_saved"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Consumer<PostListProvider>(
                        builder: (context, value, child) {
                          if(value.postListDraft == null){
                            return const SizedBox.shrink();
                          }else{
                            return SizedBox(
                              height: 150,
                              width: 175,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.postListDraft!.length,
                                itemBuilder: (context, index) {
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        widget.onChoose(value.postListDraft![index].pid);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: DraftTile(
                                          draftTitle: value.postListDraft![index].mainTitle,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      )
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }
}
