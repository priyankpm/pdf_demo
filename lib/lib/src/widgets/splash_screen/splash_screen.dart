import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider.dart';
import '../../styles/resources.dart';

/// Minimal Splash Screen
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(splashViewModelProvider).pushCreateAccountScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Resources res = ref.read(resourceProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/splash/ss.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}