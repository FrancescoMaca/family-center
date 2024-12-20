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
    apiKey: 'AIzaSyC2GUrWPRnDSkTxrTTY0prOWRm0lNXFsyA',
    appId: '1:15107123800:web:bc7fbe55a9238f52e9f82d',
    messagingSenderId: '15107123800',
    projectId: 'family-center-6321f',
    authDomain: 'family-center-6321f.firebaseapp.com',
    storageBucket: 'family-center-6321f.firebasestorage.app',
    measurementId: 'G-BF8V04TR44',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWYVHeOzbCynYlvHkE-HMWiIBY6ZfEkiQ',
    appId: '1:15107123800:android:91107765b63b42f9e9f82d',
    messagingSenderId: '15107123800',
    projectId: 'family-center-6321f',
    storageBucket: 'family-center-6321f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKoDuBtkvKicws_cDgrG-YHNbMSEvu4gQ',
    appId: '1:15107123800:ios:5ddd0dc8a235d898e9f82d',
    messagingSenderId: '15107123800',
    projectId: 'family-center-6321f',
    storageBucket: 'family-center-6321f.firebasestorage.app',
    iosBundleId: 'com.swondi.test',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKoDuBtkvKicws_cDgrG-YHNbMSEvu4gQ',
    appId: '1:15107123800:ios:b7e5ce82fb7720d2e9f82d',
    messagingSenderId: '15107123800',
    projectId: 'family-center-6321f',
    storageBucket: 'family-center-6321f.firebasestorage.app',
    iosBundleId: 'com.example.familyCenter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC2GUrWPRnDSkTxrTTY0prOWRm0lNXFsyA',
    appId: '1:15107123800:web:862a9da5e858e08fe9f82d',
    messagingSenderId: '15107123800',
    projectId: 'family-center-6321f',
    authDomain: 'family-center-6321f.firebaseapp.com',
    storageBucket: 'family-center-6321f.firebasestorage.app',
    measurementId: 'G-C22HV3Q906',
  );
}
