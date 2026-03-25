
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
    apiKey: 'AIzaSyDwIiE_94qmnN1bqOZremX1Ua1UTm1awNY',
    appId: '1:763742703305:web:9e5601d97e10f7d7ce4718',
    messagingSenderId: '763742703305',
    projectId: 'eventtoria',
    authDomain: 'eventtoria.firebaseapp.com',
    storageBucket: 'eventtoria.firebasestorage.app',
    measurementId: 'G-99CEHXFL3C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAx7lrGMqryY4ka87Hv26aBIQboUP4jCkQ',
    appId: '1:763742703305:android:e2e7726f1dd3e519ce4718',
    messagingSenderId: '763742703305',
    projectId: 'eventtoria',
    storageBucket: 'eventtoria.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiTGFDgen8g09c60JHu6z6s0cmLoXShZM',
    appId: '1:763742703305:ios:ba96ba76b9ab87d8ce4718',
    messagingSenderId: '763742703305',
    projectId: 'eventtoria',
    storageBucket: 'eventtoria.firebasestorage.app',
    iosBundleId: 'com.example.eventtoria',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDiTGFDgen8g09c60JHu6z6s0cmLoXShZM',
    appId: '1:763742703305:ios:ba96ba76b9ab87d8ce4718',
    messagingSenderId: '763742703305',
    projectId: 'eventtoria',
    storageBucket: 'eventtoria.firebasestorage.app',
    iosBundleId: 'com.example.eventtoria',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDwIiE_94qmnN1bqOZremX1Ua1UTm1awNY',
    appId: '1:763742703305:web:ec447aa72991a758ce4718',
    messagingSenderId: '763742703305',
    projectId: 'eventtoria',
    authDomain: 'eventtoria.firebaseapp.com',
    storageBucket: 'eventtoria.firebasestorage.app',
    measurementId: 'G-Y09VDBY5SZ',
  );
}