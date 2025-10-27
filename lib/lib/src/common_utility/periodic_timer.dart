import 'dart:async';
import 'package:flutter/cupertino.dart';

class PeriodicTimer {
  Timer? _timer;

  void startPeriodicTimer(
    void Function(int) onUpdateCallBack,
    VoidCallback onCompleteCallBack, {
    int duration = 0,
  }) {
    bool isCompleted = false;
    final DateTime startDateTime = DateTime.now();
    if (_timer != null && _timer!.isActive) {
      stopPeriodicTimer();
    }
    if (duration <= 0) {
      onCompleteCallBack();

      return;
    }
    int counter = 0;
    onUpdateCallBack(counter);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      counter = DateTime.now().difference(startDateTime).inSeconds;
      onUpdateCallBack(counter);
      if (duration != 0 && counter >= duration && !isCompleted) {
        isCompleted = true;
        onUpdateCallBack(counter);
        onCompleteCallBack();
        stopPeriodicTimer();
      }
    });
  }

  bool get periodicTimerIsActive => _timer?.isActive ?? false;

  /// Stops the periodic timer if it is currently running.
  /// Returns nothing.
  void stopPeriodicTimer() {
    _timer?.cancel();
  }
}
