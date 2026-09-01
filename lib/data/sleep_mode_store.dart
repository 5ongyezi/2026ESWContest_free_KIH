import 'dart:async';
import 'package:flutter/material.dart';

class SleepModeStore extends ChangeNotifier {
  SleepModeStore._() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _checkSchedule());
  }
  static final SleepModeStore instance = SleepModeStore._();

  bool isSleeping = false;
  bool scheduleEnabled = false;
  TimeOfDay? scheduleStart;
  TimeOfDay? scheduleEnd;

  late final Timer _timer;

  void setManualSleeping(bool value) {
    if (scheduleEnabled) return;
    isSleeping = value;
    notifyListeners();
  }

  void setSchedule({required bool enabled, TimeOfDay? start, TimeOfDay? end}) {
    scheduleEnabled = enabled;
    scheduleStart = start;
    scheduleEnd = end;
    _checkSchedule();
    notifyListeners();
  }

  void _checkSchedule() {
    if (!scheduleEnabled || scheduleStart == null || scheduleEnd == null) return;
    final now = TimeOfDay.now();
    final within = _isWithin(now, scheduleStart!, scheduleEnd!);
    if (isSleeping != within) {
      isSleeping = within;
      notifyListeners();
    }
  }

  bool _isWithin(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMin = now.hour * 60 + now.minute;
    final startMin = start.hour * 60 + start.minute;
    final endMin = end.hour * 60 + end.minute;
    if (startMin <= endMin) {
      return nowMin >= startMin && nowMin < endMin;
    } else {
      return nowMin >= startMin || nowMin < endMin;
    }
  }
}