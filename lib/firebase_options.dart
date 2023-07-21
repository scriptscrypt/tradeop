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
    apiKey: 'AIzaSyA_v-iA_Iotie7uzacP_lvlsA_m7TqH7os',
    appId: '1:679970923566:web:11158a7727bf9305816bbf',
    messagingSenderId: '679970923566',
    projectId: 'foreseetestapp',
    authDomain: 'foreseetestapp.firebaseapp.com',
    storageBucket: 'foreseetestapp.appspot.com',
    measurementId: 'G-PYMX9K4T2G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2sZRYP4fpiU2a8RBNJtwBJiQiv6HDhMA',
    appId: '1:679970923566:android:105aedded4c76d78816bbf',
    messagingSenderId: '679970923566',
    projectId: 'foreseetestapp',
    storageBucket: 'foreseetestapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3x2Mau2t59YxhtXAzUrDZjE4WK6m-aFE',
    appId: '1:679970923566:ios:754827ffcbf83f1c816bbf',
    messagingSenderId: '679970923566',
    projectId: 'foreseetestapp',
    storageBucket: 'foreseetestapp.appspot.com',
    iosClientId: '679970923566-r321m96vbha0007s728i6dneu8c5tr7o.apps.googleusercontent.com',
    iosBundleId: 'com.example.tradex',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC3x2Mau2t59YxhtXAzUrDZjE4WK6m-aFE',
    appId: '1:679970923566:ios:754827ffcbf83f1c816bbf',
    messagingSenderId: '679970923566',
    projectId: 'foreseetestapp',
    storageBucket: 'foreseetestapp.appspot.com',
    iosClientId: '679970923566-r321m96vbha0007s728i6dneu8c5tr7o.apps.googleusercontent.com',
    iosBundleId: 'com.example.tradex',
  );
}
