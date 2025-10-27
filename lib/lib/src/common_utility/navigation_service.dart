import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Exits the application.
  ///
  /// The [animated] parameter is an optional boolean value that indicates whether the exit animation should be played.
  ///
  /// Returns a [Future] that completes when the application has been successfully exited.
  Future<void> exitApp({bool? animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }

  /// Pushes a named route onto the navigator stack and returns a future that completes when the pushed route is popped.
  ///
  /// - `routeName`: The name of the route to push onto the navigator stack. Must not be null.
  /// - `arguments`: Optional arguments to be passed to the new route.
  ///
  /// Returns a future that completes with the value returned by the pushed route's `Navigator.pop` method, if any. If the pushed route does not return a value, the future completes with null.
  ///
  /// The function logs the name of the pushed route using a logger with the log level set to debug.
  Future<dynamic> pushNamed(String? routeName, {Object? arguments}) async {
    routeName ??= '';

    return navigatorKey.currentState!.pushNamed<dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  /// Pushes a route onto the navigator's stack and returns a future that completes when the pushed route is popped.
  ///
  /// The `route` parameter is the route to be pushed onto the stack. The type of the route can be any type that
  /// extends the `Route<dynamic>` class.
  ///
  /// Returns a [Future] that completes with a dynamic value when the pushed route is popped.
  Future<dynamic> push(Route<dynamic> route) async {

    return navigatorKey.currentState!.push<dynamic>(route);
  }

  /// Pushes a replacement named route onto the navigator stack.
  ///
  /// The [routeName] parameter is the name of the route to push.
  ///
  /// The [args] parameter is an optional argument that can be passed to the pushed route.
  ///
  /// Returns a [Future] that completes with the result of the route being pushed, if any.
  ///
  /// The logger will log the information about the route being pushed.
  ///
  /// Example:
  /// ```dart
  /// pushReplacementNamed('/home', args: {'userId': 1});
  /// ```

  Future<dynamic> pushReplacementNamed(String routeName, {Object? args}) async {

    return navigatorKey.currentState!.pushReplacementNamed<dynamic, dynamic>(
      routeName,
      arguments: args,
    );
  }

  /// Pushes a named route on top of the navigation stack and removes all routes until a condition is met.
  ///
  /// The [routeName] parameter signifies the name of the route to be pushed on top of the stack.
  /// The optional [args] parameter represents the arguments to be passed to the pushed route.
  /// Returns a [Future<dynamic>] that completes with the future result of pushing the route.
  /// Throws an error if the [navigatorKey.currentState] is null.
  ///
  /// Example usage:
  /// ```dart
  /// pushNamedAndRemoveUntil('/home', args: user);
  /// ```
  ///
  /// This method internally uses the `pushNamedAndRemoveUntil` method of the [navigatorKey.currentState] object,
  ///  and it passes a function that returns [false] to remove all the routes until the current route.
  ///
  /// Note: To use this function, make sure to have a [navigatorKey] associated with your navigator.
  ///
  /// Returns the future result of pushing the route.
  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? args,
  }) async {

    return navigatorKey.currentState!.pushNamedAndRemoveUntil<dynamic>(
      routeName,
      (Route<dynamic> route) => false,
      arguments: args,
    );
  }

  /// Pushes a named route onto the navigator and removes all the previous routes
  /// until the specified [predicate] returns true. Optionally, you can pass [args]
  /// as arguments to the route.
  ///
  /// It logs the route name and then uses the [navigatorKey] to access the navigator's
  /// currentState to perform the push and remove operation.
  ///
  /// - [routeName]: The name of the route to push.
  /// - [predicate]: A function that determines when to stop removing routes.
  /// - [args]: Optional arguments to pass to the route.
  ///
  /// Returns a [Future] of dynamic, indicating the result of pushing the route.
  Future<dynamic> pushNamedAndRemoveUntilWithPredicate(
    String routeName,
    RoutePredicate predicate, {
    Object? args,
  }) async {

    return navigatorKey.currentState!.pushNamedAndRemoveUntil<dynamic>(
      routeName,
      predicate,
      arguments: args,
    );
  }

  /// pop routes -> list of route names to be popped if available in stack
  Future<dynamic> pushNamedAndRemoveUntilWithPopRoutes(
    String routeName,
    List<String>? popRoutes, {
    Object? args,
  }) async {


    return navigatorKey.currentState!.pushNamedAndRemoveUntil<dynamic>(
      routeName,
      (Route<dynamic> route) {
        if (popRoutes != null && popRoutes.contains(route.settings.name)) {

          return false;
        }

        return true;
      },
      arguments: args,
    );
  }

  /// A function that tries to close the current route and return a boolean value
  /// indicating whether the pop operation was successfully performed or not.
  ///
  /// It takes an optional argument `args` of type `Object?` which is used as an
  /// argument to pass the result of the pop operation, if any.
  ///
  /// The return type of this function is `Future<bool>`, which represents a future
  /// boolean value indicating whether the pop operation was successful (`true`)
  /// or not (`false`).
  ///
  Future<bool> maybePop([Object? args]) async {
    return navigatorKey.currentState!.maybePop<Object>(args);
  }

  bool canPop() => navigatorKey.currentState!.canPop();

  /// Goes back to the previous screen and optionally passes a result.
  ///
  /// The [result] parameter is an optional dynamic value that can be passed back to the previous screen.
  ///
  /// This function logs a message indicating a back navigation and then pops the current screen off the navigation stack.
  ///
  /// This function does not return anything.
  void goBack({dynamic result}) {
    navigatorKey.currentState!.pop<dynamic>(result);
  }

  /// Pops the navigator until a specific route with the given name is reached.
  ///
  /// The `name` argument is a required String parameter specifying the name
  /// of the route to be reached.
  ///
  /// This function logs a debug message using `priny.d()` to indicate the
  /// action being performed, including the value of `name`.
  ///
  /// The navigatorKey's currentState is used to access the current state of the
  /// navigator, and the `popUntil` method is invoked on it, with a
  /// `ModalRoute.withName()` argument to specify the route to pop until.
  ///
  /// This function does not return anything.
  ///
  void popUntil({required String name}) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(name));
  }

  /// Pops the current navigation stack until a route meets the given predicate.
  ///
  /// The [predicate] is a function that takes a [Route] and returns a [bool].
  /// The function should return `true` for the route that needs to be popped.
  ///
  /// This function logs a debug message with the route name before popping the routes.
  ///
  /// Throws an exception if [navigatorKey] is null or if [navigatorKey.currentState] is null.
  ///
  /// Returns void.
  void popUntilWithPredicate(RoutePredicate predicate) {
    navigatorKey.currentState!.popUntil(predicate);
  }

  String getCurrentRoute() {
    String? currentPath;
    navigatorKey.currentState?.popUntil((Route<dynamic> route) {
      print('[ROUTE] route found = ${route.settings.name}');
      currentPath = route.settings.name;

      return true;
    });

    return currentPath ?? '';
  }

  /// pop routes -> list of route names to be popped if available in stack
  Future<void> popUntilWithPopRoutes(
    List<String>? popRoutes,
  ) async {
    print('[ROUTE] pop until with PopRoutes , popRoutes = $popRoutes');
    navigatorKey.currentState!.popUntil(
      (Route<dynamic> route) {
        if (popRoutes != null && popRoutes.contains(route.settings.name)) {
          print('[ROUTE PATHS] pop true');

          return false;
        }
        print('[ROUTE PATHS] pop false');

        return true;
      },
    );
  }
}
