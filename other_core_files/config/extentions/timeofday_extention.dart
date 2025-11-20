import 'package:flutter/material.dart';

extension TimeofdatExtentionFormatting on TimeOfDay {
  String formatTimeOfDay() {
    final hour = hourOfPeriod == 0 ? 12 : this.hour;
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  String format24() {
    final String hourStr = hour.toString().padLeft(2, '0');
    final String minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  bool get isAm {
    return hour < 12;
  }
}