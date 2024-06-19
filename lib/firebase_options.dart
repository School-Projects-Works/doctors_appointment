// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCQIuH0e7cajByxc82nbBT1zBvrTelMm-M',
    appId: '1:1024541304136:web:4d1e7b02eaa9b70aafbf7d',
    messagingSenderId: '1024541304136',
    projectId: 'doctors-appointment-3f8fa',
    authDomain: 'doctors-appointment-3f8fa.firebaseapp.com',
    storageBucket: 'doctors-appointment-3f8fa.appspot.com',
    measurementId: 'G-XXDS13GJZY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdhf2mgvwxk6VoZVkbQHZjwMLoP_N7GtE',
    appId: '1:1024541304136:android:87c1ff6317049045afbf7d',
    messagingSenderId: '1024541304136',
    projectId: 'doctors-appointment-3f8fa',
    storageBucket: 'doctors-appointment-3f8fa.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCQIuH0e7cajByxc82nbBT1zBvrTelMm-M',
    appId: '1:1024541304136:web:b2d8587d42348209afbf7d',
    messagingSenderId: '1024541304136',
    projectId: 'doctors-appointment-3f8fa',
    authDomain: 'doctors-appointment-3f8fa.firebaseapp.com',
    storageBucket: 'doctors-appointment-3f8fa.appspot.com',
    measurementId: 'G-NSL2SKG90T',
  );
}
