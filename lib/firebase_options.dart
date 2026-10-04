// File generated for Firebase configuration.
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
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA05i1Yx8dWle8QLZFBv_4tGNSDIajLw3Q',
    appId: '1:874067410015:web:f091257efcf59c0f0dafea',
    messagingSenderId: '874067410015',
    projectId: 'fir-a75ce',
    authDomain: 'fir-a75ce.firebaseapp.com',
    storageBucket: 'fir-a75ce.firebasestorage.app',
    measurementId: 'G-D1V9YDK6GB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1jzqwyZOBpzWJog16vcQyo6sGUZwpDno',
    appId: '1:874067410015:android:892b0bc815c92bcf0dafea',
    messagingSenderId: '874067410015',
    projectId: 'fir-a75ce',
    storageBucket: 'fir-a75ce.firebasestorage.app',
  );
}
