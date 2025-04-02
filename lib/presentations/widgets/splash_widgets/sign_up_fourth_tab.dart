import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/post_tag.dart';

class SignUpFourthTab extends StatefulWidget {
  final TextEditingController descriptionController;
  final List<String> professions;
  final Function(List<String> profession, String description) goNext;
  final Function() goBack;
  const SignUpFourthTab({
    Key? key,
    required this.goNext,
    required this.goBack,
    required this.descriptionController, 
    required this.professions,
  }) : super(key: key);

  @override
  State<SignUpFourthTab> createState() => _SignUpFourthTabState();
}

class _SignUpFourthTabState extends State<SignUpFourthTab> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController professionController = TextEditingController();
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _tapPosition = const Offset(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("signin_description_title"),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    child: SizedBox(
                        height: 37,
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextFormField(
                            onFieldSubmitted: (val) => addNewProfession(),
                            controller: professionController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, left: 10),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                hintText: ""),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () => addNewProfession(),
                      child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromARGB(255, 255, 219, 59),
                          child: Icon(Icons.add)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                  width: 350,
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.professions.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTapDown: _storePosition,
                        onLongPress: () async =>
                            await _showPopupMenu(context, index),
                        child: Tag(
                          text: widget.professions[index],
                          background: const [  
                            Color.fromARGB(255, 0, 0, 0),
                            Color.fromARGB(255, 32, 32, 32),
                            Color.fromARGB(255, 75, 75, 75)],
                          textColor: Colors.white,
                          )),
                  )),
            ),
            const Divider(
              color: Colors.white,
            ),
            Text(
              tr("signin_description_body"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: TextFormField(
                  controller: widget.descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      isDense: true,
                      hintStyle: TextStyle(fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      hintText: ""),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.goNext(widget.professions,
                          widget.descriptionController.text);
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    constraints: const BoxConstraints(
                        maxHeight: 45,
                        maxWidth: 400,
                        minHeight: 30,
                        minWidth: 100),
                    child: Center(
                        child: Text(
                      tr("signin_complete"),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () => widget.goBack(),
                          child: Text(
                            tr("back_to_previous"),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void addNewProfession() {
    if (professionController.text.isNotEmpty) {
      setState(() {
        widget.professions.add(professionController.text);
        professionController.text = "";
      });
    }
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _showPopupMenu(BuildContext context, int index) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition! & const Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem<int>(
            onTap: () {
              setState(() {
                professionController.text = widget.professions[index];
                widget.professions.remove(widget.professions[index]);
              });
            },
            child: Text(tr("modify"))),
        PopupMenuItem<int>(
            onTap: () {
              setState(() {
                widget.professions.remove(widget.professions[index]);
              });
            },
            child: Text(tr("remove"))),
      ],
      elevation: 8.0,
    );
  }
}
