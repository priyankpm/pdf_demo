import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_pixels.dart';
import '../resources.dart';

abstract class BaseTheme {
  Color get overlaysSolidStatusbarGrey105;

  Color get blue100;

  Color get overlaysAcrylicYellowDefault;

  Color get fillsBlackDefault;

  Color get grey100;

  Color get enabled2Dark;

  Color get blackPure;

  Color get black120;

  Color get avatarsPlaceholderPureWhite;

  Color get overlaysSolidFlash;

  Color get fillsGreenDefault;

  Color get paleGrey;

  Color get fillsSnowGrey;

  Color get fillsSmokeGrey;

  Color get fillsCharcoalDefault;

  Color get lightOrange;

  Color get red100;

  Color get fillsRedDefault;

  Color get enabled1Dark;

  Color get overlaysSolidWhitePureWhite060;

  Color get overlaysSolidStatusbarDesaturateYellow;

  Color get overlaysSolidStatusbarPureWhite080;

  Color get buttonsRaisedNoBorderGrey080060;

  Color get fillsBlackDefault60;

  Color get fillsBlueDefaultLight60;

  Color get fillsRedDefaultLight;

  Color get fillsGreenDefaultLight;

  Color get fillsYellowDefaultLight;

  Color get fillsOrangeDefaultLight;

  Color get flash;

  Color get shadowColor;

  Color get transparent;

  Color get fillsBlueDefaultLight100;

  Color get fillsGreenDefault40;

  Color get blue10040;

  Color get fillsRedDefault40;

  Color get lightOrange40;

  Color get blue0a84ff;

  Color get extremelyTransparentBlack;

  Color get fadedBlack;

  Color get semiTransparent;

  Color get pureWhite;

  Color get paleBlue;

  Color get darkMaroonGray;

  Color get darkTransparentBlack;

  Color get lightGray97;

  Color get darkOrange;

  Color get greyB7B7;

  Color get darkBrown;

  Color get checkBoxColor;

  Color get lightYellow;

  Color get boldGrey;

  Color get yellowBrownMix;

  Color get paleYellow;

  Color get appbarColor;

  Color get thoughtBubbleColor;

  Color get bottomBarVideoColor;

  Color get lightBlack;

  Color get lightGrey;

  Color get chatAnimalColor;

  Color get shareAvatar;

  Color get lightGolden;

  Color get darkGolden;

  Color get backButtonColor;

  Color get greyLight;

  Color get greySecondary;

  Color get grey200;

  Color get creamPrimary;

  LinearGradient get buttonGradient;
}

class AppStyle {
  const AppStyle(this.baseTheme, this.appPixels);

  final BaseTheme baseTheme;
  final AppPixels appPixels;

  ThemeData get appTheme => ThemeData(
    primaryColor: baseTheme.enabled2Dark,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light().copyWith(
      surface: baseTheme.fillsBlackDefault,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: baseTheme.fillsBlackDefault,
      selectionHandleColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: baseTheme.avatarsPlaceholderPureWhite,
  );

  TextStyle get interExtraBold34 => GoogleFonts.inter(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 34,
    height: 1.0,
    letterSpacing: 0.0,
  );

  TextStyle get interBold14 => GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.0,
    letterSpacing: 0.0,
  );

  TextStyle get interBold120 => GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    height: 1.0,
    letterSpacing: 0.0,
  );

  TextStyle get black80016 =>
      GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16, height: 1.2);

  TextStyle get white70016 => GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.0,
    letterSpacing: 0,
    color: Colors.white, // required as base before gradient
  );

  TextStyle get white70014 => GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.0,
    color: Colors.white,
  );

  TextStyle get black70014 => GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.0,
    color: Colors.black,
  );

  TextStyle get black50025 => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 25,
    height: 1.0,
    color: Colors.black,
  );

  TextStyle get black50015 => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.0,
    color: Colors.black,
  );
  TextStyle get black30015 => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.0,
    color: Colors.black45,
  );
  TextStyle get black50010 => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.0,
    color: Colors.black.withOpacity(0.63),
  );

  TextStyle get black60010 => GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.0,
    color: Colors.black,
  );

  TextStyle get black600100 => GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 10,
    height: 1.0,
    color: Colors.black,
  );

  TextStyle get black60016 => GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.0,
    color: Colors.black,
  );

  TextStyle get black40016 => GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.0,
    color: Colors.black,
  );
}
