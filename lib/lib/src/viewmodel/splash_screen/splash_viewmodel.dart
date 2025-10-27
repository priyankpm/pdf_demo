import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/common_utility/common_utility.dart';
import 'package:whiskers_flutter_app/src/provider.dart';

class SplashViewModel {
  SplashViewModel(this.ref);

  final Ref ref;

  void pushCreateAccountScreen() {
    Future<void>.delayed(Duration(seconds: splashDuration), () {
      ref
          .read(navigationServiceProvider)
          .pushReplacementNamed(RoutePaths.createAccount);
    });
  }

  Future<void> initalizeLibs() async {
    final AppSharedPref pref = await ref.read(sharedPreferencesProvider.future);
    await pref.initPref();
    ref.read(packageVersionUtilProvider).init();
  }
}
