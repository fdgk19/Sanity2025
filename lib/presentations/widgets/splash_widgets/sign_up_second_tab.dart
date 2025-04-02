import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SignUpSecondTab extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final bool showBackButton;
  final Function(String name, String surname)
      goNext;
  final Function() goBack;
  const SignUpSecondTab({
    Key? key,
    required this.goNext,
    required this.goBack, required this.nameController, required this.surnameController, required this.showBackButton,
  }) : super(key: key);

  @override
  State<SignUpSecondTab> createState() => _SignUpSecondTabState();
}

class _SignUpSecondTabState extends State<SignUpSecondTab> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("enter_name"),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 20),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: Row(
                  children: [
                    SizedBox(
                        height: 37,
                        width: 270,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextFormField(
                            controller: widget.nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Inserisci nome';
                              }
                              return null;
                            },
                            maxLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, left: 10),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                hintText: "Nome"),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                tr("enter_surname"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: Row(
                  children: [
                    SizedBox(
                        height: 37,
                        width: 270,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextFormField(
                            controller: widget.surnameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Inserisci cognome';
                              }
                              return null;
                            },
                            maxLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, left: 10),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                hintText: "Cognome"),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.goNext(
                          widget.nameController.text,
                          widget.surnameController.text);
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
                      tr("continue"),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.showBackButton,
              child: Padding(
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
            ),
          ],
        ),
      ),
    );
  }
}
