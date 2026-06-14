import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerFirebaseWebPlugin() {
  FirebaseCoreWeb.registerWith(webPluginRegistrar);
}
