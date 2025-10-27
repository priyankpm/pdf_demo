import 'package:flutter/material.dart';
// Define a mixin class that implements WidgetsBindingObserver
abstract class ILifecycleState with WidgetsBindingObserver {
  LifecycleStateListener? lifecycleStateListener;

  void register(LifecycleStateListener lifecycleStateListener);

  void unRegister();
}

mixin class LifecycleStateListener {
  /// This function is called when the application resumes.
  /// It is intended to be implemented by the developer.
  /// There are no input arguments.
  /// The return type is void.
  void onResume() {
    // TODO(developername): need to implement.
  }

  /// Callback function called when the flow is paused.
  ///
  /// This function is called when the flow is paused. It is a placeholder function
  /// that needs to be implemented by the developer with the appropriate logic.
  ///
  /// No input arguments are required.
  ///
  /// Returns `void`.
  void onPaused() {
    // TODO(developername): need to implement.
  }

  /// Marks the function as inactive.
  void inActive() {
    // TODO(developername): need to implement.
  }

  /// This function is used to handle detached events.
  ///
  /// It does not take any input arguments.
  ///
  /// It does not return anything.
  void detached() {
    // TODO(developername): need to implement.
  }
}
