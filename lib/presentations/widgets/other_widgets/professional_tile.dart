import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sanity_web/data/models/user_model.dart';

class ProfessionalTile extends StatelessWidget {
  final UserModel user;
  const ProfessionalTile({Key? key, required this.user,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                        image:user.photoUrl != null && user.photoUrl!.isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(user.photoUrl!), fit: BoxFit.cover,)
                        : const DecorationImage(image: AssetImage(
                                  "lib/resources/images/logosanity.png"),
                                   fit: BoxFit.cover,),
                        borderRadius: const BorderRadius.all( Radius.circular(50)),
                        //borderRadius: BorderRadius.circular(12)
                        ),
                  ),
                // CircleAvatar(
                // radius: 16,
                // child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                // ? Image.network(user.photoUrl!, fit: BoxFit.cover,)
                // : Image.asset("lib/resources/images/logosanity.png")
                //    ),
              
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                         Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                           child: Text(
                            "${tr(user.gender ?? tr("Dr"))} ${user.name} ${user.surname}",
                             style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                              ),
                         ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 2),
                          child: user.isPremium
                          ?  SvgPicture.asset(
                              width: 12,
                              height: 12,
                              color: Colors.blue,
                              "lib/resources/images/certificate.svg")
                          : const SizedBox.shrink()
                        )
                      ],
                    ),
                     Text(
                      user.mainProfesion ?? " ",
                      style: const TextStyle(color: Color.fromARGB(255, 214, 214, 214), fontSize: 11),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
  }
}