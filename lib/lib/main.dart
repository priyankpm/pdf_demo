import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whiskers_flutter_app/firebase_options.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/memory_frame_storage.dart';
import 'package:whiskers_flutter_app/src/widgets/splash_screen/app_root.dart';
import 'package:whiskers_flutter_app/src/common_utility/common_utility.dart';

/// Entry point of the app.
void main() async {
  await setup();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: AppRoot()));
}

/// Will do the initial setup of the app.
Future<void> setup() async {
  // Ensures that the Flutter framework is properly initialized before using any Flutter APIs
  WidgetsFlutterBinding.ensureInitialized();
  SvgAssetLoader loader = SvgAssetLoader(whiskerSplashLogo);
  await Supabase.initialize(
    url: 'https://api.whiskers-dev.onesol.in',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE',
  );
  //  TODO: use logger
  print('Initialized Supabase client: ${Supabase.instance.client}');
  await Hive.initFlutter();
  SvgAssetLoader whiskerSplashLogoSVG = SvgAssetLoader(whiskerSplashLogo);
  await svg.cache.putIfAbsent(
    loader.cacheKey(null),
    () => loader.loadBytes(null),
  );
  await svg.cache.putIfAbsent(whiskerSplashLogo, () => loader.loadBytes(null));
  await svg.cache.putIfAbsent(
    whiskerSplashLogoSVG,
    () => loader.loadBytes(null),
  );
  await svg.cache.putIfAbsent(
    loader.cacheKey(null),
    () => loader.loadBytes(null),
  );

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) {
      return stack.vmTrace;
    }
    if (stack is stack_trace.Chain) {
      return stack.toTrace().vmTrace;
    }

    return stack;
  };
}
