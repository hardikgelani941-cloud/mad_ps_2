import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA44lnAvp-Nc8iGjHUIv1hIItY2lEHsMso',
    appId: '1:273434367573:web:1e251c0f032e8fd3e0e6dc',
    messagingSenderId: '273434367573',
    projectId: 'library-ps2-hardik',
    authDomain: 'library-ps2-hardik.firebaseapp.com',
    storageBucket: 'library-ps2-hardik.firebasestorage.app',
    measurementId: 'G-CBG7CFQXNX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA44lnAvp-Nc8iGjHUIv1hIItY2lEHsMso',
    appId: '1:273434367573:web:1e251c0f032e8fd3e0e6dc',
    messagingSenderId: '273434367573',
    projectId: 'library-ps2-hardik',
    storageBucket: 'library-ps2-hardik.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA44lnAvp-Nc8iGjHUIv1hIItY2lEHsMso',
    appId: '1:273434367573:web:1e251c0f032e8fd3e0e6dc',
    messagingSenderId: '273434367573',
    projectId: 'library-ps2-hardik',
    storageBucket: 'library-ps2-hardik.firebasestorage.app',
    iosBundleId: 'com.example.madPs2',
  );
}
