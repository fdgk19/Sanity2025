import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/data/models/notification_model.dart';
import 'package:sanity_web/presentations/state_management/notification_provider.dart';

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  const NotificationItem({
    super.key, required this.notification,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 159, 158, 158), width: 0.3)),
      height: 80,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14,5,5,5),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: widget.notification.fromImage.isNotEmpty 
                  ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 25,
                    backgroundImage:  NetworkImage(widget.notification.fromImage)
                  )
                  : const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 25,
                    backgroundImage: AssetImage("lib/resources/images/profile_placeholder.png")
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.notification.fromFullName,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      widget.notification.fromCertificate 
                      ? Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, left: 2, right: 10),
                          child: SvgPicture.asset(
                              width: 9,
                              height: 9,
                              color: Colors.blue,
                              "lib/resources/images/certificate.svg"),
                        )
                      : const SizedBox.shrink()
                    ],
                  ),
                  Text(
                     widget.notification.body ?? "",
                     style: const TextStyle(
                       fontSize: 12, 
                       color: Colors.black),
                   ),
                ],
              ),
              IconButton(
                splashRadius: 5,
                onPressed: ()async{
                  await context.read<NotificationProvider>().deleteNotification(notId: widget.notification.nid);
                }, 
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
