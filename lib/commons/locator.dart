import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sanity_web/commons/firestore/firestore_service.dart';
import 'package:sanity_web/commons/routing/router.gr.dart';
import 'package:sanity_web/data/services/interfaces/notification_service.dart';
import 'package:sanity_web/data/services/interfaces/post_service.dart';
import 'package:sanity_web/data/services/interfaces/stripe_service.dart';
import 'package:sanity_web/data/services/interfaces/user_service.dart';
import 'package:sanity_web/data/services/notification_service_impl.dart';
import 'package:sanity_web/data/services/post_service_impl.dart';
import 'package:sanity_web/data/services/stripe_service_impl.dart';
import 'package:sanity_web/data/services/user_service_impl.dart';
import 'package:sanity_web/firebase_options.dart';
import 'package:sanity_web/presentations/state_management/auth_provider.dart';
import 'package:sanity_web/presentations/state_management/new_post_provider.dart';
import 'package:sanity_web/presentations/state_management/notification_provider.dart';
import 'package:sanity_web/presentations/state_management/post_detail_provider.dart';
import 'package:sanity_web/presentations/state_management/post_provider.dart';
import 'package:sanity_web/presentations/state_management/stripe_provider.dart';
import 'package:sanity_web/presentations/state_management/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


GetIt locator = GetIt.instance;

Future<void> setupDi()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //register provider
  locator.registerFactory(
    () => PostListProvider(postService: locator(), sharedPreferences: locator(), userService: locator()),
  );
  locator.registerFactory(
    () => AuthProvider(userService: locator(), sharedPreferences: locator()),
  );
  locator.registerFactory(
    () => NewPostProvider(userService: locator(), postService: locator(), sharedPreferences: locator()),
  );
  locator.registerFactory(
    () => StripeProvider(stripeService: locator(), sharedPreferences: locator(), userService: locator()),
  );
  locator.registerFactory(
    () => UserListProvider(sharedPreferences: locator(), userService: locator(), postService: locator()),
  );
  locator.registerFactory(
    () => PostDetailProvider(sharedPreferences: locator(), userService: locator(), postService: locator()),
  );
  locator.registerFactory(
    () => NotificationProvider(sharedPreferences: locator(), notificationService: locator()),
  );

  //register service
  locator.registerFactory<PostService>(
      () => PostServiceImpl(firestoreService: locator()));
  locator.registerFactory<UserService>(
      () => UserServiceImpl(firestoreService: locator()));
  locator.registerFactory<NotificationService>(
      () => NotificationServiceImpl(firestoreService: locator()));
  locator.registerFactory<StripeService>(
      () => StripeServiceImpl(firestoreService: locator()));


  //register external dependencies
  final sharedPref = await SharedPreferences.getInstance();
  final firestoreService = FirestoreService.instance;
  locator.registerFactory(() => sharedPref);
  locator.registerFactory(() => firestoreService);
  locator.registerLazySingleton<AppRouter>(() => AppRouter());
}