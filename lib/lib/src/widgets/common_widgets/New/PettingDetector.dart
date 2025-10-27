// common_widgets/petting_detector.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class PettingDetector extends StatefulWidget {
  final Function(Rect) onPettingDetected;

  const PettingDetector({super.key, required this.onPettingDetected});

  @override
  _PettingDetectorState createState() => _PettingDetectorState();
}

class _PettingDetectorState extends State<PettingDetector> {
  final Random _random = Random();
  Timer? _pettingTimer;

  @override
  void initState() {
    super.initState();
    _startPettingDetection();
  }

  void _startPettingDetection() {
    _pettingTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_random.nextDouble() > 0.7) { // 30% chance of petting detection
        final boundingBox = Rect.fromLTWH(
          _random.nextDouble() * 200,
          _random.nextDouble() * 200,
          100 + _random.nextDouble() * 100,
          100 + _random.nextDouble() * 100,
        );
        widget.onPettingDetected(boundingBox);
      }
    });
  }

  @override
  void dispose() {
    _pettingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(); // Invisible detector that covers entire screen
  }
}