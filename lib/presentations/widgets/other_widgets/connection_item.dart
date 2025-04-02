import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';

import '../../../commons/routing/router.gr.dart';

class ConnectionItem extends StatefulWidget {
  final UserModel user;
  final bool isFollowerView;
  const ConnectionItem(
      {super.key, required this.user, required this.isFollowerView});

  @override
  State<ConnectionItem> createState() => _ConnectionItemState();
}

class _ConnectionItemState extends State<ConnectionItem> {
  bool isRemoved = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MouseRegion(cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap:() =>  AutoRouter.of(context).push(ProfileDetailRoute( uid: widget.user.uid)),
                child: Row(
                  children: [
                    Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                            image:  widget.user.photoUrl != null && widget.user.photoUrl!.isNotEmpty
                            ? DecorationImage(
                              image: NetworkImage(widget.user.photoUrl!), fit: BoxFit.cover,)
                            : const DecorationImage(image: AssetImage(
                                      "lib/resources/images/logosanity.png"),
                                      fit: BoxFit.cover,),
                            borderRadius: const BorderRadius.all( Radius.circular(50)),
                            //borderRadius: BorderRadius.circular(12)
                            ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${widget.user.gender} ${widget.user.name} ${widget.user.surname}",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Visibility(
                                visible: widget.user.isPremium,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8.0, left: 2),
                                  child: SvgPicture.asset(
                                      width: 12,
                                      height: 12,
                                      color: Colors.blue,
                                      "lib/resources/images/certificate.svg"),
                                ),
                              )
                            ],
                          ),
                          Text(widget.user.mainProfesion!,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.isFollowerView
                ? const SizedBox.shrink()
                : MouseRegion(
                    cursor: isRemoved
                        ? MouseCursor.defer
                        : SystemMouseCursors.click,
                    child: GestureDetector(
                        onTap: () async {
                          if (!isRemoved) {
                            await context
                                .read<AuthProvider>()
                                .removeFollow(widget.user.uid);
                            if (mounted) {
                              await context
                                  .read<UserListProvider>()
                                  .getFollowingUsers();
                            }
                            setState(() {
                              isRemoved = true;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isRemoved ? Colors.red : Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 80,
                          height: 40,
                          child: Center(
                              child: Text(
                            isRemoved ? tr("removed") : tr("remove"),
                            style: const TextStyle(fontSize: 13, color: Colors.white),
                          )),
                        )))
          ],
        ),
      ),
    );
  }
}
