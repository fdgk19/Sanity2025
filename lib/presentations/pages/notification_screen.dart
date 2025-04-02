import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/notification_provider.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {      
      context.read<NotificationProvider>().getAllNotification(userId: context.read<AuthProvider>().currentUser.uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<NotificationProvider>(
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
                      shrinkWrap: true,
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
        ],
        ),
      );  
  }
}