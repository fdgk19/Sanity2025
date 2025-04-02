import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/presentations/state_management/notification_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/notification_item.dart';


class NotificationDrawer extends StatefulWidget {
  const NotificationDrawer({super.key});

  @override
  State<NotificationDrawer> createState() => _NotificationDrawerState();
}

class _NotificationDrawerState extends State<NotificationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding( padding: const EdgeInsets.only(top:60.0),
      child: Drawer( 
        width: 250,
        child: Consumer<NotificationProvider>(
          builder: (context, value, child) {
            if(value.loading || value.notificationList == null){
              return Center(
                heightFactor: 10.0,
                child: LoadingAnimationWidget.beat(
                  color: const Color.fromARGB(255, 255, 177, 59),
                  size: 60,
                ),
              );
            }else if(value.notificationList!.isEmpty){
              return const SizedBox.shrink();
            }else{
              return ListView.builder(
                itemCount: value.notificationList!.length,
                itemBuilder: ((context, index) {
                  return NotificationItem(
                    notification: value.notificationList![index],
                  );
                }),
              );
            }
          }
        )
      ),
    );
  }
}