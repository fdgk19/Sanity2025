import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart';

class NewProfessionalTile extends StatelessWidget {

  final UserModel user;
  const NewProfessionalTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:13.0),
      child: Column(
        children: [
           user.photoUrl != null && user.photoUrl!.isNotEmpty
          ? CircleAvatar(
           backgroundColor: Colors.transparent,
           radius: 40,
           backgroundImage:  NetworkImage(user.photoUrl!),
          )
          : const CircleAvatar(
           backgroundColor: Colors.blue,
           radius: 40,
           backgroundImage: AssetImage("lib/resources/images/logosanity.png")
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                    constraints: const BoxConstraints(maxWidth: 130),
                     child: Tooltip(
                      message: "${tr(user.gender ?? tr("Dr"))} ${user.name} ${user.surname}",
                       child: Text(
                        "${tr(user.gender ?? tr("Dr"))} ${user.name} ${user.surname}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                     ),
                   ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
                      child: user.isPremium
                      ? SvgPicture.asset(
                          width: 12,
                          height: 12,
                          color: Colors.blue,
                            "lib/resources/images/certificate.svg")
                       : const SizedBox.shrink()
                     ),
                ],
             ),
          ),
          Text(
            user.mainProfesion ?? "",
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
          Container(
                constraints: const BoxConstraints(maxWidth: 120),
            child: Tooltip(
              message: "${user.address} ${user.city}",
              child: Text(
                "${user.address} ${user.city}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }
}



class NewProfessionalTileMobile extends StatelessWidget {

  final UserModel user;
  const NewProfessionalTileMobile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Column(
            children: [   user.photoUrl != null && user.photoUrl!.isNotEmpty
          ? CircleAvatar(
           backgroundColor: Colors.transparent,
           radius: 30,
           backgroundImage:  NetworkImage(user.photoUrl!)
          )
          : const CircleAvatar(
           backgroundColor: Colors.transparent,
           radius: 30,
           backgroundImage: AssetImage("lib/resources/images/profile_placeholder.png")
          ),],
          ),
          
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "${user.gender} ${user.name} ${user.surname}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 2),
                      child: user.isPremium
                      ? SvgPicture.asset(
                          width: 12,
                          height: 12,
                          color: Colors.blue,
                            "lib/resources/images/certificate.svg")
                       : const SizedBox.shrink()
                     ),
                ],
             ),
          ),
          Text(
            user.mainProfesion ?? "",
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
          Text(
            "${user.address}, ${user.city}",
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          )
        ],
      ),
    );
  }
}
