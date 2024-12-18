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
      return website; 
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQkKrEqUO_I0JF4H8DWTm8Gwddd7Xztvk',
    appId: '1:1060757861870:ios:7ba42aceff69dc71ae0aff',
    messagingSenderId: '1060757861870',
    projectId: 'db-money-map',
    storageBucket: 'db-money-map.firebasestorage.app',
    iosBundleId: 'com.example.finalProject',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNsYeXrbwhHTfFA1bfKaCEQYsnDARpS1c',
    appId: '1:1060757861870:android:7ba42aceff69dc71ae0aff',
    messagingSenderId: '1060757861870',
    projectId: 'db-money-map',
    storageBucket: 'db-money-map.firebasestorage.app',
    androidClientId: 'com.example.finalProject',
  );

  static const FirebaseOptions website = FirebaseOptions(
    apiKey: "AIzaSyATfYa8tchVR2HJBxvtBaHPoUE5PNqV9fs",
    authDomain: "db-money-map.firebaseapp.com",
    projectId: "db-money-map",
    storageBucket: "db-money-map.firebasestorage.app",
    messagingSenderId: "1060757861870",
    appId: "1:1060757861870:web:09c0d38ae3e10447ae0aff",
    measurementId: "G-WNKTG07HYZ"
  );
}