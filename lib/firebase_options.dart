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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAon5lB1z8ErILgXbeipsZ0mU7V4Ig0Q0E',
    appId: '1:932663043506:web:ef2a75cd61002e4b07f0ab',
    messagingSenderId: '932663043506',
    projectId: 'suscult-39f00',
    authDomain: 'suscult-39f00.firebaseapp.com',
    storageBucket: 'suscult-39f00.appspot.com',
    measurementId: 'G-015H9K3TF3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJOI4zjhyYri0U5zmDyvYHpw-UJVfJHoc',
    appId: '1:932663043506:android:f610a0b17428307f07f0ab',
    messagingSenderId: '932663043506',
    projectId: 'suscult-39f00',
    storageBucket: 'suscult-39f00.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDONqZJj08lSsTsuLQJxtZriAJV6dC5aBI',
    appId: '1:932663043506:ios:369cf3377d4525c607f0ab',
    messagingSenderId: '932663043506',
    projectId: 'suscult-39f00',
    storageBucket: 'suscult-39f00.appspot.com',
    iosBundleId: 'com.example.helloWorld',
  );
}