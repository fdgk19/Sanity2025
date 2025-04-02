import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/widgets/settings_widget/settings_single_tab.dart';

class SecurityAndAccessSettings extends StatefulWidget {
  const SecurityAndAccessSettings({super.key});

  @override
  State<SecurityAndAccessSettings> createState() => _SecurityAndAccessSettingsState();
}

class _SecurityAndAccessSettingsState extends State<SecurityAndAccessSettings> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController newMailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration:   BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.grey, width: 0.3)
              ),
              width: sizingInformation.deviceScreenType != DeviceScreenType.mobile
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10),
                  child: Text(tr("account_access"), style:const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                ),
                Padding(
                 padding: const EdgeInsets.only(left: 10, right: 10),
                 child: SingleSettingTab(
                  text:(tr("change_email")), 
                  onButtonPress: () { 
                    showMailDialog();
                   },),
               ),
               const Divider(thickness: 0.6),
               Padding(
                 padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                 child: SingleSettingTab(
                  text:(tr("change_password")), 
                  onButtonPress: () { 
                    showPasswordDialog();
                  },),
               ),
               sizingInformation.deviceScreenType == DeviceScreenType.mobile
               ? const Divider(thickness: 0.6)
               : const SizedBox.shrink(),
               sizingInformation.deviceScreenType == DeviceScreenType.mobile
               ? GestureDetector(
                 onTap: () {
                   context.read<AuthProvider>().signOut();
                 },
                 child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10,  bottom: 10),
                   child: Text(tr("logout"), style:const TextStyle(fontSize: 19, fontWeight: FontWeight.normal, color: Colors.red),),
                 ),
               )
               : const SizedBox.shrink()
              ],),
            ),
            
          ],
        ),
      ),
    );
  }

  void showSuccess(String type)async{
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "$type avvenuto con successo!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        actions: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
                AutoRouter.of(context).pop();
            },
            child: Text(
              tr("ok"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void showError(String type)async{
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "C'è stato un errore nella procedura di $type",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        actions: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
                AutoRouter.of(context).pop();
            },
            child: Text(
              tr("ok"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void showMailDialog() async{
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Cambio email",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        content: 
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding:EdgeInsets.only(top: 8, bottom: 8.0),
                child: Text(
                  "Inserisci nuova email",
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: SizedBox(
                    height: 37,
                    width: 250,
                    child: TextFormField(
                      controller: newMailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Inserisci email valida";
                        } else {
                          return null;
                        }
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                      bottom: 14,
                                      left: 10),
                              border: InputBorder.none,),
                    )),
              ),
              const Padding(
                padding:EdgeInsets.only(top: 8, bottom: 8.0),
                child: Text(
                  "Inserisci password",
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: SizedBox(
                    height: 37,
                    width:250,
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Inserisci password valida";
                        } else {
                          return null;
                        }
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                      bottom: 14,
                                      left: 10),
                              border: InputBorder.none,),
                    )),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            color: Colors.red,
            onPressed: () {
              AutoRouter.of(context).pop(false);
            },
            child: Text(
              tr("back"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
                if (_formKey.currentState!.validate()) {
                AutoRouter.of(context).pop(true);
              }
            },
            child: Text(
              tr("continue"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ).then((valueFromDialog) async {
      if (valueFromDialog != null && valueFromDialog) {
        var res = await context.read<AuthProvider>().resetEmail(newMailController.text, passwordController.text);
        if(res){
          showSuccess("Cambio email");
        }else{
          showError("Cambio email");
        }
      }
      newMailController.text = "";
      passwordController.text = "";
    });
  }
  
  void showPasswordDialog() async{
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Modifica password",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
        content: 
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding:EdgeInsets.only(top: 8, bottom: 8.0),
                child: Text(
                  "Inserisci vecchia Password",
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: SizedBox(
                    height: 37,
                    width: 250,
                    child: TextFormField(
                      obscureText: true,
                      controller: oldPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Inserisci password valida";
                        } else {
                          return null;
                        }
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                      bottom: 14,
                                      left: 10),
                              border: InputBorder.none,),
                    )),
              ),
              const Padding(
                padding:EdgeInsets.only(top: 8, bottom: 8.0),
                child: Text(
                  "Inserisci nuova Password",
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: SizedBox(
                    height: 37,
                    width:250,
                    child: TextFormField(
                      obscureText: true,
                      controller: newPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Inserisci password valida";
                        } else {
                          return null;
                        }
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                      bottom: 14,
                                      left: 10),
                              border: InputBorder.none,),
                    )),
              ),
              const Padding(
                padding:EdgeInsets.only(top: 8, bottom: 8.0),
                child: Text(
                  "Conferma nuova Password",
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child: SizedBox(
                    height: 37,
                    width:250,
                    child: TextFormField(
                      obscureText: true,
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Inserisci password valida";
                        } else if (value != newPasswordController.text) {
                          return 'Password non corrispondente';
                        }else {
                          return null;
                        }
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                      bottom: 14,
                                      left: 10),
                              border: InputBorder.none,),
                    )),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            color: Colors.red,
            onPressed: () {
              AutoRouter.of(context).pop(false);
            },
            child: Text(
              tr("back"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
                if (_formKey.currentState!.validate()) {
                AutoRouter.of(context).pop(true);
              }
            },
            child: Text(
              tr("continue"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ).then((valueFromDialog) async {
      if (valueFromDialog != null && valueFromDialog) {
        var res = await context.read<AuthProvider>().updatePassword(oldPasswordController.text, newPasswordController.text);
        if(res){
          showSuccess("Modifica password");
        }else{
          showError("Modifica password");
        }
      }
      oldPasswordController.text = "";
      newPasswordController.text = "";
      confirmPasswordController.text = "";
    });
  }

}