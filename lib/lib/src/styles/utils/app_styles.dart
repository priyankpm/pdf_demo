import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum AppFontStyle {
  regular,
  medium,
  semibold,
  bold,
}

extension AppFontStyleExtension on AppFontStyle {
  String get fontFamily => 'Inter';

  FontWeight get fontWeight {
    switch (this) {
      case AppFontStyle.regular:
        return FontWeight.w400;
      case AppFontStyle.medium:
        return FontWeight.w500;
      case AppFontStyle.semibold:
        return FontWeight.w600;
      case AppFontStyle.bold:
        return FontWeight.w700;
    }
  }

  static AppFontStyle fromString(String value) {
    switch (value.toLowerCase()) {
      case 'regular':
        return AppFontStyle.regular;
      case 'medium':
        return AppFontStyle.medium;
      case 'semibold':
        return AppFontStyle.semibold;
      case 'bold':
        return AppFontStyle.bold;
      default:
        return AppFontStyle.regular;
    }
  }
}

class AppTextStyle {
  TextStyle commonTextStyle({
    double? fontSize,
    Color? textColor,
    AppFontStyle? appFontStyle,
    TextDecoration? decoration,
    Color? decorationColor,
    double? height = 0
  }) {
    final style = AppFontStyleExtension.fromString(appFontStyle?.name ?? 'medium');
    return TextStyle(
        fontSize: fontSize ?? 14,
        fontFamily: style.fontFamily,
        fontWeight: style.fontWeight,
        color: textColor,
        decoration: decoration,
        decorationColor: decorationColor,
        height: height
    );
  }
}