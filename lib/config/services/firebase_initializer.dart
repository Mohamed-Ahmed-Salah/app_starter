import 'package:app_starter/config/utils/util_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// import 'package:attendance/firebase_options_production.dart' as prod;
// import 'package:attendance/firebase_options_dev.dart' as dev;


///initialize firebase => firebase messaging => notification service
Future<void> initializeFirebaseApp() async {
  // final firebaseOptions = switch (appFlavor) {
  //   'production' => prod.DefaultFirebaseOptions.currentPlatform,
  //   'dev' => dev.DefaultFirebaseOptions.currentPlatform,
  //   _ => throw UnsupportedError('Invalid flavor: $appFlavor'),
  // };
  // await Firebase.initializeApp(options: firebaseOptions);
  // UtilFunctions.appLog("✅ Firebase initialized with flavor $appFlavor");
}
