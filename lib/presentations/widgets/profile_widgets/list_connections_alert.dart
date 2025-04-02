import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/data/models/user_model.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/connection_item.dart';

class ListConnectionsAlert extends StatefulWidget {
  final List<UserModel> userListFollowing;
  final bool isFollowerView;
  const ListConnectionsAlert({super.key, required this.userListFollowing, required this.isFollowerView});

  @override
  State<ListConnectionsAlert> createState() => _ListConnectionsAlertState();
}

class _ListConnectionsAlertState extends State<ListConnectionsAlert> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => 
        AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
                decoration:const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 254, 25, 25),
                      Color.fromARGB(255, 111, 83, 224),
                      Color.fromARGB(255, 50, 140, 162),
                      Color.fromARGB(255, 20, 182, 100),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                constraints: BoxConstraints(
                    maxHeight: 630,
                    maxWidth: widget.isFollowerView ? 350 : 550,
                    minHeight: 70,
                    minWidth: widget.isFollowerView ? 350 : 550),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text(
                          widget.isFollowerView ? tr("followers") : tr("connections"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 480,
                        width: widget.isFollowerView ? 350 : 550,
                        child: ListView.builder(
                          itemCount: widget.userListFollowing.length,
                          itemBuilder: (context, index) {
                            return ConnectionItem(
                              user: widget.userListFollowing[index], 
                              isFollowerView: widget.isFollowerView,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
