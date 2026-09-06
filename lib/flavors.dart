import 'package:firebase_core/firebase_core.dart';
import 'package:app_starter/core/constants/network_constants.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;

enum Flavor { dev, prod }

/// Per-flavor configuration. `F.appFlavor` is set once in `init()` from
/// Flutter's built-in `appFlavor` (`flutter run --flavor dev`).
class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title => switch (appFlavor) {
    Flavor.dev => 'App Starter Dev',
    Flavor.prod => 'App Starter',
  };

  static FirebaseOptions get firebaseOptions => switch (appFlavor) {
    Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
    Flavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
  };

  static String get baseUrl => switch (appFlavor) {
    Flavor.dev => NetworkConstants.devUrl,
    Flavor.prod => NetworkConstants.prodUrl,
  };

  static Future<void> initializeFirebaseApp() async {
    await Firebase.initializeApp(options: firebaseOptions);
    // ignore: avoid_print
    print("✅ Firebase initialized with flavor: $name");
  }
}
