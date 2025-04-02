import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sanity_web/commons/locator.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/state_management/notification_provider.dart';
import 'package:sanity_web/presentations/state_management/post_detail_provider.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/state_management/stripe_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';

List<SingleChildWidget> providerList = [
  ChangeNotifierProvider<NewPostProvider>(create: (_) => locator<NewPostProvider>()),
  ChangeNotifierProvider<PostListProvider>(create: (_) => locator<PostListProvider>()),
  ChangeNotifierProvider<AuthProvider>(create: (_) => locator<AuthProvider>()),
  ChangeNotifierProvider<StripeProvider>(create: (_) => locator<StripeProvider>()),
  ChangeNotifierProvider<UserListProvider>(create: (_) => locator<UserListProvider>()),
  ChangeNotifierProvider<PostDetailProvider>(create: (_) => locator<PostDetailProvider>()),
  ChangeNotifierProvider<NotificationProvider>(create: (_) => locator<NotificationProvider>()),
];