import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/view/schedule_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/splash_screen/splash_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/video_screen/activity_screens/memory_wall_screen.dart';

import '../../common_utility/common_utility.dart';
import '../../logger/log_handler.dart';
import '../../provider.dart';
import '../../styles/resources.dart';
import '../../util/app_router.dart';
import '../../util/navigation_manager.dart';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key}) : super();

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot>
    with LifecycleStateListener, WidgetsBindingObserver {
  late final NavigationService _navigationService;
  late final AppRouter _appRouter;
  late final Resources _res;
  late final Logger _logger;
  late ILifecycleState iLifecycleState;

  @override
  void initState() {
    super.initState();
    _navigationService = ref.read(navigationServiceProvider);
    _appRouter = ref.read(appRouterProvider);
    _logger = ref.read(loggerProvider);

    NavigationManager.instance.setupNavigationRoutes(_appRouter);
    routeObserver = ref.read(routeObserverProvider);
    _res = ref.read(resourceProvider);
    iLifecycleState = LifecycleStateImpl();
    iLifecycleState.register(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage(dogPngLogo), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define your fixed logical size and DPR
    final Size _ = Size(
      _res.appPixels.dp360,
      _res.appPixels.dp360 * 2,
    );
    const double fixedDPR = 2.0;

    // Calculate the scaling factor
    final FlutterView window = View.of(context);
    // Override MediaQuery with fixed values
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      window,
    );

    return MediaQuery(
      data: mediaQuery,
      child: WillPopScope(
        onWillPop: () async {
          if (_navigationService.navigatorKey.currentState?.canPop() ?? false) {
            _navigationService.goBack();
            return false;
          }
          return true;
        },
        child: MaterialApp(
          title: '$appName App',
          theme: _res.themes.appTheme,
          navigatorObservers: <NavigatorObserver>[routeObserver],
          navigatorKey: _navigationService.navigatorKey,
          onGenerateRoute: _appRouter.generateRoute,
          builder: (_, Widget? wid) {
            if (wid != null) {
              return ScrollConfiguration(
                behavior: AppScrollBehaviour(),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.noScaling,
                    devicePixelRatio: 2.0,
                  ),
                  child: wid,
                ),
              );
            }

            return const SizedBox.shrink();
          },
          home: SplashScreen(),
          // home: MemoryWallScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logger.i('Disposing AppRoot');
    super.dispose();
  }
}

class AppScrollBehaviour extends ScrollBehavior {
  const AppScrollBehaviour();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
