import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override

  /// Returns a widget that renders an empty box with no dimensions.
  ///
  /// The `context` argument specifies the build context for this widget.
  ///
  /// The return value is an instance of the `SizedBox` widget, which is a box
  /// widget with zero dimensions.
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
