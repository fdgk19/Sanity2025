// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_0QMpQZbhuIgddjEHxbZeRD8KaQupJLE',
    appId: '1:902628732577:web:d42e00789163281d850ae0',
    messagingSenderId: '902628732577',
    projectId: 'sanity-ef53f',
    authDomain: 'sanity-ef53f.firebaseapp.com',
    databaseURL: 'https://sanity-ef53f-default-rtdb.firebaseio.com',
    storageBucket: 'sanity-ef53f.appspot.com',
    measurementId: 'G-ZTG181WVS8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9Qx0IIFrkwscMTbsy5PV17rDb56nNW_o',
    appId: '1:902628732577:android:1b589af0b47665dd850ae0',
    messagingSenderId: '902628732577',
    projectId: 'sanity-ef53f',
    databaseURL: 'https://sanity-ef53f-default-rtdb.firebaseio.com',
    storageBucket: 'sanity-ef53f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBc-bDMaCcSH_Tz1hljcC9RAgh71Z3wLHU',
    appId: '1:902628732577:ios:028245cbdff0f0f7850ae0',
    messagingSenderId: '902628732577',
    projectId: 'sanity-ef53f',
    databaseURL: 'https://sanity-ef53f-default-rtdb.firebaseio.com',
    storageBucket: 'sanity-ef53f.appspot.com',
    androidClientId: '902628732577-2dnr98mkuu5cm3s62ojq8e9sgbn9rcg1.apps.googleusercontent.com',
    iosClientId: '902628732577-rmf3v0lfsheocgti656ps1cc60js760s.apps.googleusercontent.com',
    iosBundleId: 'com.example.sanityWeb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBc-bDMaCcSH_Tz1hljcC9RAgh71Z3wLHU',
    appId: '1:902628732577:ios:028245cbdff0f0f7850ae0',
    messagingSenderId: '902628732577',
    projectId: 'sanity-ef53f',
    databaseURL: 'https://sanity-ef53f-default-rtdb.firebaseio.com',
    storageBucket: 'sanity-ef53f.appspot.com',
    androidClientId: '902628732577-2dnr98mkuu5cm3s62ojq8e9sgbn9rcg1.apps.googleusercontent.com',
    iosClientId: '902628732577-rmf3v0lfsheocgti656ps1cc60js760s.apps.googleusercontent.com',
    iosBundleId: 'com.example.sanityWeb',
  );
}
