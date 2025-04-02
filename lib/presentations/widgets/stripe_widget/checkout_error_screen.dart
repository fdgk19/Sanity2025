import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';

class CheckoutError extends StatelessWidget {
  const CheckoutError({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>().resetStripeField();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child:Container(
            height: 60,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 254, 25, 25),
                Color.fromARGB(255, 111, 83, 224),
                Color.fromARGB(255, 50, 140, 162),
                Color.fromARGB(255, 20, 182, 100)
              ])),
              child:  const SizedBox.shrink(),
            )
          ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("lib/resources/images/error.svg", color: Colors.red, width: 200, height: 200,),
             Padding(
              padding: const EdgeInsets.fromLTRB(20,40,20,0),
              child: Text(tr("checkout_error_message"),textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),
            ),
             Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: SizedBox(
                width: 370,
                child: Text(tr("subscription_error_message"), style: const TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.italic), textAlign: TextAlign.center,)),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: ElevatedButton(
                onPressed: () {
                AutoRouter.of(context).push(const MainRoute());
              },
              child: Text(tr("back_to_home"))),
            )
          ],
        ),
      ),
    );
  }
}
