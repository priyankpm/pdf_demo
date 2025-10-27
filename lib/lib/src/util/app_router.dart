import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_utility/common_utility.dart';

bool isSplashLoaded = false;
late final RouteObserver<PageRoute<dynamic>> routeObserver;

/// A class representing the app router.
class AppRouter {
  /// A map containing route names and their corresponding widget builders.
  Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{};
  static String? _lastRoute = '/';

  static String? get lastRoute => _lastRoute;

  Route<dynamic> generateRoute(RouteSettings settings) {
    _lastRoute = settings.name;
    if (!isSplashLoaded) {
      isSplashLoaded = true;

      return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (BuildContext context, _, __) {
          return routeMap[settings.name!]!(context);
        },
        transitionsBuilder: (_, Animation<double> a, _, Widget c) =>
            FadeTransition(opacity: a, child: c),
      );
    }
    if (settings.name == null) {
      // If settings.name is null, return a fallback route.
      return CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) => const Text('Unknown Route'),
        settings: settings,
      );
    }

    return settings.name == RoutePaths.splashScreen
        ? MaterialPageRoute<dynamic>(
            builder: routeMap[settings.name]!,
            settings: settings,
            fullscreenDialog: true,
            ///disable back gesture
          )
        : CupertinoPageRoute<dynamic>(
            builder: routeMap[settings.name]!,
            settings: settings,
          );
  }
}
