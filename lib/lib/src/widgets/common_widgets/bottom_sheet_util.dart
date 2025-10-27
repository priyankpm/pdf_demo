import 'package:flutter/material.dart';

class BottomSheetUtil {
  /// Reusable generic bottom sheet
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
      builder: (_) => child,
    );
  }
}
