import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      _ => throw UnsupportedError(
        'FirebaseOptions are not configured for this platform.',
      ),
    };
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCY4bfcFDLfIFQ-15_BeTChfFVW1COf1Ig',
    appId: '1:377790341326:web:dcdf3c5681d47f64aa309f',
    messagingSenderId: '377790341326',
    projectId: 'vilasmagazine-oficial',
    authDomain: 'vilasmagazine-oficial.firebaseapp.com',
    storageBucket: 'vilasmagazine-oficial.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAD6W_XSdhF9v51ilIDPF2o4DBSZWvS_g',
    appId: '1:377790341326:android:cfa5a0c857f39f0baa309f',
    messagingSenderId: '377790341326',
    projectId: 'vilasmagazine-oficial',
    storageBucket: 'vilasmagazine-oficial.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZJw3LYTaYXb7utnwFEDHKlb-SIIVuu_M',
    appId: '1:377790341326:ios:432dabcc62f7f7a1aa309f',
    messagingSenderId: '377790341326',
    projectId: 'vilasmagazine-oficial',
    storageBucket: 'vilasmagazine-oficial.firebasestorage.app',
    iosBundleId: 'com.salles.vilasmagazine',
  );
}
