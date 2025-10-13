import 'package:flutter/material.dart';

extension TimeofdatExtentionFormatting on TimeOfDay {
  String formatTimeOfDay() {
    final hour = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool get isAm {
    return hour < 12;
  }
}