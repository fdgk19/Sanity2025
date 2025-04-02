// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:flutter/material.dart' as _i14;
import 'package:sanity_web/presentations/pages/assistance_screen.dart' as _i11;
import 'package:sanity_web/presentations/pages/home_screen.dart' as _i6;
import 'package:sanity_web/presentations/pages/main_screen.dart' as _i1;
import 'package:sanity_web/presentations/pages/notification_screen.dart' as _i7;
import 'package:sanity_web/presentations/pages/professional_detail_post_screen.dart'
    as _i5;
import 'package:sanity_web/presentations/pages/professional_detail_screen.dart.dart'
    as _i4;
import 'package:sanity_web/presentations/pages/profile_screen.dart' as _i8;
import 'package:sanity_web/presentations/pages/research_screen.dart' as _i12;
import 'package:sanity_web/presentations/pages/settings_screen.dart' as _i10;
import 'package:sanity_web/presentations/pages/subscription_screen.dart' as _i9;
import 'package:sanity_web/presentations/widgets/stripe_widget/checkout_error_screen.dart'
    as _i2;
import 'package:sanity_web/presentations/widgets/stripe_widget/checkout_successfully_screen.dart'
    as _i3;

class AppRouter extends _i13.RootStackRouter {
  AppRouter([_i14.GlobalKey<_i14.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    MainRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.MainScreen(),
      );
    },
    CeckoutErrorRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.CheckoutError(),
      );
    },
    CeckoutSuccessRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.CheckoutSuccess(),
      );
    },
    ProfileDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileDetailRouteArgs>(
          orElse: () =>
              ProfileDetailRouteArgs(uid: pathParams.getString('uid')));
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.ProfileDetailScreen(
          key: args.key,
          uid: args.uid,
        ),
      );
    },
    ProfilePostDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfilePostDetailRouteArgs>(
          orElse: () => ProfilePostDetailRouteArgs(
                uid: pathParams.getString('uid'),
                postId: pathParams.getString('postId'),
              ));
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.ProfileDetailPostScreen(
          key: args.key,
          uid: args.uid,
          postId: args.postId,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.HomeScreen(),
      );
    },
    NotificationRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.NotificationScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.ProfileScreen(),
      );
    },
    SubscriptionRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i9.SubscriptionScreen(),
      );
    },
    SettingRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.SettingsScreen(),
      );
    },
    AssistanceRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i11.AssistanceScreen(),
      );
    },
    ResearchRoute.name: (routeData) {
      return _i13.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i12.ResearchScreen(),
      );
    },
  };

  @override
  List<_i13.RouteConfig> get routes => [
        _i13.RouteConfig(
          MainRoute.name,
          path: '/',
          children: [
            _i13.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: MainRoute.name,
            ),
            _i13.RouteConfig(
              NotificationRoute.name,
              path: 'notification',
              parent: MainRoute.name,
            ),
            _i13.RouteConfig(
              ProfileRoute.name,
              path: 'profile',
              parent: MainRoute.name,
            ),
            _i13.RouteConfig(
              SubscriptionRoute.name,
              path: 'subscriptions',
              parent: MainRoute.name,
            ),
            _i13.RouteConfig(
              SettingRoute.name,
              path: 'settings',
              parent: MainRoute.name,
            ),
            _i13.RouteConfig(
              AssistanceRoute.name,
              path: 'assistance',
              parent: MainRoute.name,
            ),
            _i13.RouteConfig(
              ResearchRoute.name,
              path: 'search',
              parent: MainRoute.name,
            ),
            _i13.RouteConfig(
              '*#redirect',
              path: '*',
              parent: MainRoute.name,
              redirectTo: '',
              fullMatch: true,
            ),
          ],
        ),
        _i13.RouteConfig(
          CeckoutErrorRoute.name,
          path: '/checkouterror',
        ),
        _i13.RouteConfig(
          CeckoutSuccessRoute.name,
          path: '/checkoutsuccess',
        ),
        _i13.RouteConfig(
          ProfileDetailRoute.name,
          path: '/profiledetail/:uid',
          usesPathAsKey: true,
        ),
        _i13.RouteConfig(
          ProfilePostDetailRoute.name,
          path: '/profiledetail/:uid/post/:postId',
          usesPathAsKey: true,
        ),
      ];
}

/// generated route for
/// [_i1.MainScreen]
class MainRoute extends _i13.PageRouteInfo<void> {
  const MainRoute({List<_i13.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'MainRoute';
}

/// generated route for
/// [_i2.CheckoutError]
class CeckoutErrorRoute extends _i13.PageRouteInfo<void> {
  const CeckoutErrorRoute()
      : super(
          CeckoutErrorRoute.name,
          path: '/checkouterror',
        );

  static const String name = 'CeckoutErrorRoute';
}

/// generated route for
/// [_i3.CheckoutSuccess]
class CeckoutSuccessRoute extends _i13.PageRouteInfo<void> {
  const CeckoutSuccessRoute()
      : super(
          CeckoutSuccessRoute.name,
          path: '/checkoutsuccess',
        );

  static const String name = 'CeckoutSuccessRoute';
}

/// generated route for
/// [_i4.ProfileDetailScreen]
class ProfileDetailRoute extends _i13.PageRouteInfo<ProfileDetailRouteArgs> {
  ProfileDetailRoute({
    _i14.Key? key,
    required String uid,
  }) : super(
          ProfileDetailRoute.name,
          path: '/profiledetail/:uid',
          args: ProfileDetailRouteArgs(
            key: key,
            uid: uid,
          ),
          rawPathParams: {'uid': uid},
        );

  static const String name = 'ProfileDetailRoute';
}

class ProfileDetailRouteArgs {
  const ProfileDetailRouteArgs({
    this.key,
    required this.uid,
  });

  final _i14.Key? key;

  final String uid;

  @override
  String toString() {
    return 'ProfileDetailRouteArgs{key: $key, uid: $uid}';
  }
}

/// generated route for
/// [_i5.ProfileDetailPostScreen]
class ProfilePostDetailRoute
    extends _i13.PageRouteInfo<ProfilePostDetailRouteArgs> {
  ProfilePostDetailRoute({
    _i14.Key? key,
    required String uid,
    required String postId,
  }) : super(
          ProfilePostDetailRoute.name,
          path: '/profiledetail/:uid/post/:postId',
          args: ProfilePostDetailRouteArgs(
            key: key,
            uid: uid,
            postId: postId,
          ),
          rawPathParams: {
            'uid': uid,
            'postId': postId,
          },
        );

  static const String name = 'ProfilePostDetailRoute';
}

class ProfilePostDetailRouteArgs {
  const ProfilePostDetailRouteArgs({
    this.key,
    required this.uid,
    required this.postId,
  });

  final _i14.Key? key;

  final String uid;

  final String postId;

  @override
  String toString() {
    return 'ProfilePostDetailRouteArgs{key: $key, uid: $uid, postId: $postId}';
  }
}

/// generated route for
/// [_i6.HomeScreen]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: 'home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i7.NotificationScreen]
class NotificationRoute extends _i13.PageRouteInfo<void> {
  const NotificationRoute()
      : super(
          NotificationRoute.name,
          path: 'notification',
        );

  static const String name = 'NotificationRoute';
}

/// generated route for
/// [_i8.ProfileScreen]
class ProfileRoute extends _i13.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: 'profile',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i9.SubscriptionScreen]
class SubscriptionRoute extends _i13.PageRouteInfo<void> {
  const SubscriptionRoute()
      : super(
          SubscriptionRoute.name,
          path: 'subscriptions',
        );

  static const String name = 'SubscriptionRoute';
}

/// generated route for
/// [_i10.SettingsScreen]
class SettingRoute extends _i13.PageRouteInfo<void> {
  const SettingRoute()
      : super(
          SettingRoute.name,
          path: 'settings',
        );

  static const String name = 'SettingRoute';
}

/// generated route for
/// [_i11.AssistanceScreen]
class AssistanceRoute extends _i13.PageRouteInfo<void> {
  const AssistanceRoute()
      : super(
          AssistanceRoute.name,
          path: 'assistance',
        );

  static const String name = 'AssistanceRoute';
}

/// generated route for
/// [_i12.ResearchScreen]
class ResearchRoute extends _i13.PageRouteInfo<void> {
  const ResearchRoute()
      : super(
          ResearchRoute.name,
          path: 'search',
        );

  static const String name = 'ResearchRoute';
}
