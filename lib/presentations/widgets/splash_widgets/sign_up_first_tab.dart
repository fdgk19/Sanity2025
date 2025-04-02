import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SignUpFirstTab extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function(String mail, String password) goNext;
  final Function() goBack;
  final Function() switchBody;

  const SignUpFirstTab(
      {super.key,
      required this.goNext,
      required this.goBack,
      required this.switchBody,
      required this.emailController,
      required this.passwordController});

  @override
  State<SignUpFirstTab> createState() => _SignUpFirstTabState();
}

class _SignUpFirstTabState extends State<SignUpFirstTab> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController confirmPasswordController = TextEditingController();

  int currentPage = 1;

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
              tr("enter_mail"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 20),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Il campo email è vuoto';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                  .hasMatch(widget.emailController.text)) {
                                return "inserisci una mail valida";
                              }
                              return null;
                            },
                            controller: widget.emailController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, left: 10),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                hintText: "Email"),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Text(
              tr("enter_password"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 20),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Inerisci una password';
                              } else if (value.length <= 5) {
                                return 'Inserisci almeno 6 caratteri';
                              }
                              return null;
                            },
                            controller: widget.passwordController,
                            obscureText: true,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, left: 10),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                hintText: "Password"),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Text(
              tr("confirm_password"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 20),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Inserisci password da confermare';
                              } else if (value !=
                                  widget.passwordController.text) {
                                return 'Password non corrispondente';
                              }
                              return null;
                            },
                            controller: confirmPasswordController,
                            obscureText: true,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(bottom: 8, left: 10),
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                                hintText: "Conferma Password"),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 00.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.goNext(
                        widget.emailController.text,
                        widget.passwordController.text,
                      );
                    } else {}
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () => widget.switchBody(),
                          child: Text(
                            tr("back_to_previous"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12
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
}
