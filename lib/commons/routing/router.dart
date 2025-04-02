import 'package:auto_route/auto_route.dart';
import 'package:sanity_web/presentations/pages/assistance_screen.dart';
import 'package:sanity_web/presentations/pages/home_screen.dart';
import 'package:sanity_web/presentations/pages/main_screen.dart';
import 'package:sanity_web/presentations/pages/notification_screen.dart';
import 'package:sanity_web/presentations/pages/professional_detail_post_screen.dart';
import 'package:sanity_web/presentations/pages/professional_detail_screen.dart.dart';
import 'package:sanity_web/presentations/pages/profile_screen.dart';
import 'package:sanity_web/presentations/pages/research_screen.dart';
import 'package:sanity_web/presentations/pages/settings_screen.dart';
import 'package:sanity_web/presentations/pages/subscription_screen.dart';
import 'package:sanity_web/presentations/widgets/stripe_widget/checkout_error_screen.dart';
import 'package:sanity_web/presentations/widgets/stripe_widget/checkout_successfully_screen.dart';

//TODO: launch following command to auto-generate route file: flutter packages pub run build_runner build
//TODO: launch following command if white screen appear on start: flutter pub cache repair
@AdaptiveAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute(
      initial: true,
      page: MainScreen,
      name: 'MainRoute',
      path: '/',
      children: [
        AutoRoute(
          page: HomeScreen,
          name: 'HomeRoute',
          path: 'home',
        ),
        AutoRoute(
            page: NotificationScreen,
            name: 'NotificationRoute',
            path: 'notification'),
        AutoRoute(page: ProfileScreen, name: 'ProfileRoute', path: 'profile'),
        // AutoRoute(
        //   page: DashboardScreen,
        //   name: 'DashboardRoute',
        //   path: 'dashboard'
        // ),
        AutoRoute(
            page: SubscriptionScreen,
            name: 'SubscriptionRoute',
            path: 'subscriptions'),
        AutoRoute(page: SettingsScreen, name: 'SettingRoute', path: 'settings'),
        AutoRoute(
            page: AssistanceScreen,
            name: 'AssistanceRoute',
            path: 'assistance'),

        AutoRoute(page: ResearchScreen, name: 'ResearchRoute', path: 'search'),
        RedirectRoute(path: "*", redirectTo: "")
      ]
    ),
     AutoRoute(
          page: CheckoutError,
          name: 'CeckoutErrorRoute',
          path: '/checkouterror'
     ),
      AutoRoute(
          page: CheckoutSuccess,
          name: 'CeckoutSuccessRoute',
          path: '/checkoutsuccess'
     ),
      AutoRoute(
          page: ProfileDetailScreen,
          name: "ProfileDetailRoute",
          path: "/profiledetail/:uid",
          usesPathAsKey: true,
     ),
      AutoRoute(
        page: ProfileDetailPostScreen,
        name: "ProfilePostDetailRoute",
        path: "/profiledetail/:uid/post/:postId",
        usesPathAsKey: true,
     ),
  ]
)
class $AppRouter{}
