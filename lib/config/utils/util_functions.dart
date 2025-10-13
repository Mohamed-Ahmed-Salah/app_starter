import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class UtilFunctions {
  static void appLog(String message) {
    if (!kReleaseMode) {
      // prints only in debug or profile
      debugPrint(message);
    }
  }
}
