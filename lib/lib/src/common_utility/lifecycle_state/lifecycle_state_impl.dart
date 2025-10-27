import 'package:flutter/material.dart';

import 'i_lifecycle_state.dart';

class LifecycleStateImpl extends ILifecycleState {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        lifecycleStateListener?.detached();
        break;
      case AppLifecycleState.inactive:
        lifecycleStateListener?.inActive();
        break;
      case AppLifecycleState.paused:
        lifecycleStateListener?.onPaused();
        break;
      case AppLifecycleState.resumed:
        lifecycleStateListener?.onResume();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  @override

  /// Registers a [LifecycleStateListener] to receive lifecycle state changes.
  ///
  /// When the lifecycle state changes, the [lifecycleStateListener] will be notified.
  /// [lifecycleStateListener] should implement the [LifecycleStateListener] interface.
  ///
  /// Example usage:
  ///     LifecycleManager.register(MyStateListener());
  ///
  /// Args:
  /// - [lifecycleStateListener]: The [LifecycleStateListener] to register.
  ///
  /// Returns:
  /// - void
  void register(LifecycleStateListener lifecycleStateListener) {
    this.lifecycleStateListener = lifecycleStateListener;
    WidgetsBinding.instance.addObserver(this);
  }

  /// Removes the observer for this widget binding.
  @override
  void unRegister() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
