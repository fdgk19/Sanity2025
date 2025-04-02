import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/login_provider_result_model.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/alert_pricing.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/sign_up_fifth_tab.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/sign_up_first_tab.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/sign_up_fourth_tab.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/sign_up_third_tab.dart';
import 'package:sanity_web/presentations/widgets/splash_widgets/sign_up_second_tab.dart';

class MainSignUp extends StatefulWidget {
  final Function() switchBody;
  final LoginProviderResultModel? providerResult;

  const MainSignUp({
    super.key,
    required this.switchBody, 
    this.providerResult,
  });

  @override
  State<MainSignUp> createState() => _MainSignUpState();
}

class _MainSignUpState extends State<MainSignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> professions = [];

  bool signUpIsDoctor = false;

  int currentPage = 1;

  @override
  void initState() {

    if(widget.providerResult != null){
      setState(() {
        currentPage = 2;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return currentPage == 1
        ? SignUpFirstTab(
            goBack: () {
              setState(() {
                currentPage--;
              });
            },
            goNext: (mail, psw) async {
              var check = await authProvider.checkIfAlreadySignIn(mail);
              if (!check) {
                setState(() {
                  emailController.text = mail;
                  passwordController.text = psw;
                  currentPage++;
                });
              } else {
                if (mounted) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text(
                                tr("email_already_used"))
                          ));
                }
              }
            },
            switchBody: () => widget.switchBody(),
            emailController: emailController,
            passwordController: passwordController,
          )
        : currentPage == 2
            ? SignUpSecondTab(
                showBackButton: widget.providerResult == null,
                goNext: (name, surname) {
                  setState(() {
                    nameController.text = name;
                    surnameController.text = surname;
                    currentPage++;
                  });
                },
                goBack: () {
                  setState(() {
                    currentPage--;
                  });
                },
                nameController: nameController,
                surnameController: surnameController,
              )
            : currentPage == 3
                ? Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: SignUpThirdTab(goNext: (isDoctor) async {
                      if (!isDoctor) {
                        if(widget.providerResult != null){
                          //registrazione con provider
                          await authProvider.completeSignInWithProvider(
                            uid: widget.providerResult!.userId!,
                            email: widget.providerResult!.email!,
                            name: nameController.text,
                            surname: surnameController.text,
                            isDoctor: isDoctor);
                        }else{
                          //registrazione
                          await authProvider.registerWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              surname: surnameController.text,
                              isDoctor: isDoctor);
                        }

                      } else {
                        setState(() {
                          signUpIsDoctor = isDoctor;
                          currentPage++;
                        });
                      }
                    }, goBack: () {
                      setState(() {
                        currentPage--;
                      });
                    }),
                  )
                : currentPage == 4
                    ? SignUpFourthTab(
                        goNext: (profession, description) async {
                          professions = profession;
                          descriptionController.text = description;
                          var result = false;
                          if(widget.providerResult != null){
                            //registrazione con provider
                            result = await authProvider.completeSignInWithProvider(
                              uid: widget.providerResult!.userId!,
                              email: widget.providerResult!.email!,
                              name: nameController.text,
                              surname: surnameController.text,
                              isDoctor: signUpIsDoctor,
                              description: description,
                              profession: profession);
                          }else{
                            //signin in firebase
                            result = await authProvider.registerWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  isDoctor: signUpIsDoctor,
                                  name: nameController.text,
                                  surname: surnameController.text,
                                  description: description,
                                  profession: profession);
                          }
                          if (result) {
                            setState(() {
                              currentPage++;
                            });
                          }
                        },
                        goBack: () {
                          setState(() {
                            currentPage--;
                          });
                        },
                        descriptionController: descriptionController,
                        professions: professions)
                    : currentPage == 5
                        ? SignUpFifthTab(goNext: () {
                            setState(() {
                              currentPage++;
                            });
                          })
                        : PricingAlert(
                            goNext: () async {
                              if(widget.providerResult != null){
                                await authProvider.completeLoginWithProvider(widget.providerResult!.userId!);
                              }else{
                                await authProvider.signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);
                              }
                            },
                          );
  }
}
