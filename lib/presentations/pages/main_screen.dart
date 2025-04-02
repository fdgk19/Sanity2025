import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sanity_web/commons/enum.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/pages/splash_screen.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/state_management/notification_provider.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/create_post_alert.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/create_post_choose_alert.dart';
import 'package:sanity_web/presentations/widgets/create_post_widgets/draft_post_alert.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/help_center_alert.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/nav_bar_item.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sanity_web/presentations/widgets/other_widgets/notification_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, child) {
      if (auth.status == Status.unauthenticated) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover ,image: AssetImage("lib/resources/images/background.png"))
          ),
          child: const Center(
            child: SplashScreen(),
          ),
        );
      } else if (auth.status == Status.authenticated) {
        return AutoTabsScaffold(
  
          endDrawer:const NotificationDrawer(),
          routes: const [
            HomeRoute(),
            NotificationRoute(),
            ProfileRoute(),
            //DashboardRoute(),
            SubscriptionRoute(),
            SettingRoute(),
            AssistanceRoute(),
            ResearchRoute(),
          ],
          floatingActionButton: auth.currentUser.isDoctor
              ? FloatingActionButton(
                  heroTag: null,
                  backgroundColor: const Color.fromARGB(255, 255, 177, 59),
                  onPressed: () async => await showAlert(context),
                  child: const Icon(Icons.add),
                )
              : const SizedBox(),
          appBarBuilder: (context, tabsRouter) {
            return PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: ResponsiveBuilder(builder: (context, sizingInformation) {
                  return Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 254, 25, 25),
                      Color.fromARGB(255, 111, 83, 224),
                      Color.fromARGB(255, 50, 140, 162),
                      Color.fromARGB(255, 20, 182, 100)
                    ])),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: (){
                               context.read<PostListProvider>().getRaccomendedPosts();
                               context.read<UserListProvider>().getRaccomendedUsers();
                               tabsRouter.setActiveIndex(Options.home.index);},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                    "lib/resources/images/logosanity1.png"),
                              ),
                            ),
                          ),
                          const Spacer(),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => tabsRouter
                                  .setActiveIndex(Options.research.index),
                              child: Container(
                                height: 30,
                                width: 160,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text(
                                    tr("need_of"),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          sizingInformation.deviceScreenType ==
                                      DeviceScreenType.tablet ||
                                  sizingInformation.deviceScreenType ==
                                      DeviceScreenType.mobile
                              ? PopupMenuButton<Options>(
                                  iconSize: 25,
                                  padding: const EdgeInsets.all(0),
                                  offset: const Offset(0, 50),
                                  onSelected: (value) {
                                    if (value == Options.logout) {
                                      context
                                          .read<AuthProvider>()
                                          .signOut(); //.then((value) => AutoRouter.of(context).popUntilRoot());
                                    } else {
                                      if(value == Options.notification){
                                        context.read<NotificationProvider>().getAllNotification(userId: auth.currentUser.uid);
                                      }
                                      if(value == Options.home){
                                        context.read<PostListProvider>().getRaccomendedPosts();
                                        context.read<UserListProvider>().getRaccomendedUsers();
                                      }
                                      if(value == Options.profile){
                                        context.read<PostListProvider>().getSavedPosts();
                                        context.read<UserListProvider>().getFollowingUsers();
                                        context.read<UserListProvider>().getFollowersUsers();
                                      }
                                      tabsRouter.setActiveIndex(value.index);
                                    }},
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                  itemBuilder: (ctx) => [
                                    _buildPopupMenuItem('Home', Options.home),
                                    _buildPopupMenuItem(
                                        tr("notifications"), Options.notification),
                                    _buildPopupMenuItem(
                                        tr("profile"), Options.profile),
                                    // _buildPopupMenuItem(
                                    //     'La tua Dashboard', Options.dashboard),
                                    // _buildPopupMenuItem(
                                    //     'Abbonamento', Options.subscriptions),
                                    _buildPopupMenuItem(
                                         tr("settings"), Options.settings),
                                    // _buildPopupMenuItem(
                                    //     'Assistenza', Options.assistance),
                                    // _buildPopupMenuItem(
                                    //   'Log Out',
                                    //   Options.logout,
                                    // )
                                  ],
                                )
                              : Row(
                                  children: [
                                    NavBarItem(
                                      switchItem: (){ 
                                        context.read<PostListProvider>().getRaccomendedPosts();
                                        context.read<UserListProvider>().getRaccomendedUsers();
                                        tabsRouter.setActiveIndex(Options.home.index);},
                                      isActive: tabsRouter.activeIndex ==
                                          0, //widget.selectedTab == 0,
                                      iconActive: Icons.home,
                                      iconNotActive: Icons.home_outlined,
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                  NavBarItem(
                                      switchItem: () {
                                        context.read<NotificationProvider>().getAllNotification(userId: auth.currentUser.uid);
                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      isActive: tabsRouter.activeIndex ==
                                          1, //widget.selectedTab == 0,
                                      iconActive: Icons.notifications,
                                      iconNotActive: Icons.notifications_none,
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    NavBarItem(
                                      switchItem: (){
                                        context.read<PostListProvider>().getSavedPosts();
                                        context.read<UserListProvider>().getFollowingUsers();
                                        context.read<UserListProvider>().getFollowersUsers();
                                        tabsRouter.setActiveIndex(Options.profile.index);},
                                      isActive: tabsRouter.activeIndex ==
                                          2, //widget.selectedTab == 2,
                                      iconActive: Icons.account_circle,
                                      iconNotActive:
                                          Icons.account_circle_outlined,
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    NavBarItem(
                                      switchItem: () =>
                                          tabsRouter.setActiveIndex(
                                              Options.settings.index),
                                      isActive: tabsRouter.activeIndex ==
                                          3, //widget.selectedTab == 2,
                                      iconActive: Icons.settings,
                                      iconNotActive: Icons.settings,
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                    ),
                  );
                }));
          },
        );
      }
      return Center(
          child: LoadingAnimationWidget.beat(
        color: const Color.fromARGB(255, 255, 177, 59),
        size: 60,
      ));
    });
  }

  Future<void> showAlert(BuildContext context) async {
    await context.read<PostListProvider>().getDraftPost();
    showDialog<bool>(
        context: context,
        builder: (context) => const CreatePostChoose()).then((value) {
      if (value != null) {
        if (value) {
          showDialog(
            barrierDismissible: false,
              context: context, builder: (context) => const CreatePostAlert());
        } else {
          var currentPost = context.read<NewPostProvider>().post;
          var sectionLenght = context.read<NewPostProvider>().sectionList.length;
          showDialog(barrierDismissible: false, context: context, builder: (context) => DraftPostAlert(draftPost: currentPost!, sectionLenght: sectionLenght));
        }
      }
    });
  }

  void showHelpCenter(BuildContext context) {
    showDialog(context: context, builder: (context) => const HelpCenterAlert());
  }

  PopupMenuItem<Options> _buildPopupMenuItem(String title, Options position) {
    return PopupMenuItem<Options>(
      value: position,
      child: Column(
        children: [
          Text(title),
        ],
      ),
    );
  }
}
