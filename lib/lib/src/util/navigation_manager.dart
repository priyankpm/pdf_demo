import 'package:flutter/material.dart';

import 'app_router.dart';
import 'route_setup.dart';

/// Will contain mapping of all routes.
class NavigationManager with RouteSetup {
  NavigationManager._();

  static final NavigationManager instance = NavigationManager._();

  late final AppRouter appRouter;

  Future<void> setupNavigationRoutes(AppRouter router) async {
    appRouter = router;

    final Map<String, WidgetBuilder> appStartRoutes =
        await setupAppStartNavigationRoutes();

    appRouter.routeMap.addAll(appStartRoutes);
  }
}
