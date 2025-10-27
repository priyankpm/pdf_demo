import 'package:flutter/material.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_pixels.dart';

import '../utils/app_theme_mode.dart';
import 'base_theme.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class AppThemes {
  AppThemes(this._isLightMode,this.appPixels) {
    _selectedTheme =
        (_isLightMode == AppThemeMode.light) ? LightTheme() : DarkTheme();
    appStyle = AppStyle(_selectedTheme, appPixels);
  }

  final AppThemeMode _isLightMode;
  late BaseTheme _selectedTheme;
  late AppPixels appPixels;
  late AppStyle appStyle;


  ThemeData get appTheme => ThemeData(
    primaryColor: enabled2Dark,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light().copyWith(
      background: fillsBlackDefault,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: fillsBlackDefault,
      selectionHandleColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: avatarsPlaceholderPureWhite,
  );

  /// Exposed color that are needed by UI ***** start ******
  Color get overlaysSolidStatusbarGrey105 =>
      _selectedTheme.overlaysSolidStatusbarGrey105;

  Color get blue100 => _selectedTheme.blue100;

  Color get darkOrange => _selectedTheme.darkOrange;

  Color get greyB7B7 => _selectedTheme.greyB7B7;

  Color get overlaysAcrylicYellowDefault =>
      _selectedTheme.overlaysAcrylicYellowDefault;

  Color get fillsBlackDefault => _selectedTheme.fillsBlackDefault;

  Color get grey100 => _selectedTheme.grey100;

  Color get enabled2Dark => _selectedTheme.enabled2Dark;

  Color get blackPure => _selectedTheme.blackPure;

  Color get black120 => _selectedTheme.black120;

  Color get avatarsPlaceholderPureWhite =>
      _selectedTheme.avatarsPlaceholderPureWhite;

  Color get overlaysSolidFlash => _selectedTheme.overlaysSolidFlash;

  Color get fillsGreenDefault => _selectedTheme.fillsGreenDefault;

  Color get paleGrey => _selectedTheme.paleGrey;

  Color get fillsSnowGrey => _selectedTheme.fillsSnowGrey;

  Color get fillsSmokeGrey => _selectedTheme.fillsSmokeGrey;

  Color get fillsCharcoalDefault => _selectedTheme.fillsCharcoalDefault;

  Color get lightOrange => _selectedTheme.lightOrange;

  Color get red100 => _selectedTheme.red100;

  Color get fillsRedDefault => _selectedTheme.fillsRedDefault;

  Color get enabled1Dark => _selectedTheme.enabled1Dark;

  Color get overlaysSolidWhitePureWhite060 =>
      _selectedTheme.overlaysSolidWhitePureWhite060;

  Color get overlaysSolidStatusbarDesaturateYellow =>
      _selectedTheme.overlaysSolidStatusbarDesaturateYellow;

  Color get overlaysSolidStatusbarPureWhite080 =>
      _selectedTheme.overlaysSolidStatusbarPureWhite080;

  Color get buttonsRaisedNoBorderGrey080060 =>
      _selectedTheme.buttonsRaisedNoBorderGrey080060;

  Color get fillsBlackDefault60 => _selectedTheme.fillsBlackDefault60;

  Color get fillsBlueDefaultLight60 => _selectedTheme.fillsBlueDefaultLight60;

  Color get fillsBlueDefaultLight100 => _selectedTheme.fillsBlueDefaultLight100;

  Color get fillsRedDefaultLight => _selectedTheme.fillsRedDefaultLight;

  Color get fillsGreenDefaultLight => _selectedTheme.fillsGreenDefaultLight;

  Color get fillsYellowDefaultLight => _selectedTheme.fillsYellowDefaultLight;

  Color get fillsOrangeDefaultLight => _selectedTheme.fillsOrangeDefaultLight;

  Color get fillsRedDefault40 => _selectedTheme.fillsRedDefault40;

  Color get lightOrange40 => _selectedTheme.lightOrange40;

  Color get blue10040 => _selectedTheme.blue10040;

  Color get fillsGreenDefault40 => _selectedTheme.fillsGreenDefault40;

  Color get flash => _selectedTheme.flash;

  Color get shadowColor => _selectedTheme.shadowColor;
  Color get transparent => _selectedTheme.transparent;
  Color get overlaysSolidDarkTint020 => const Color(
        0x33000000,
      );
  Color get overlaysSolidDarkTint005 => const Color(
        0x0d000000,
      );

  Color get blue0a84ff => _selectedTheme.blue0a84ff;

  Color get extremelyTransparentBlack =>
      _selectedTheme.extremelyTransparentBlack;

  Color get fadedBlack => _selectedTheme.fadedBlack;

  Color get semiTransparent => _selectedTheme.semiTransparent;

  Color get pureWhite => _selectedTheme.pureWhite;

  Color get paleBlue => _selectedTheme.paleBlue;

  Color get darkMaroonGray => _selectedTheme.darkMaroonGray;

  Color get darkTransparentBlack => _selectedTheme.darkTransparentBlack;

  Color get lightGray97 => _selectedTheme.lightGray97;
  Color get darkBrown => _selectedTheme.darkBrown;
  Color get checkBoxColor => _selectedTheme.checkBoxColor;
  Color get lightYellow => _selectedTheme.lightYellow;
  Color get boldGrey => _selectedTheme.boldGrey;
  Color get yellowBrownMix => _selectedTheme.yellowBrownMix;
  Color get paleYellow => _selectedTheme.paleYellow;
  Color get appbarColor => _selectedTheme.appbarColor;
  Color get bottomBarVideoColor => _selectedTheme.bottomBarVideoColor;
  Color get lightBlack => _selectedTheme.lightBlack;
  Color get lightGrey => _selectedTheme.lightGrey;
  Color get chatAnimalColor => _selectedTheme.chatAnimalColor;
  Color get shareAvatar => _selectedTheme.shareAvatar;
  Color get darkGolden => _selectedTheme.darkGolden;
  Color get lightGolden => _selectedTheme.lightGolden;
  Color get backButtonColor => _selectedTheme.backButtonColor;
  Color get greyLight => _selectedTheme.greyLight;
  Color get greySecondary => _selectedTheme.greySecondary;
  Color get grey200 => _selectedTheme.grey200;
  Color get creamPrimary => _selectedTheme.creamPrimary;
  LinearGradient get buttonGradient => _selectedTheme.buttonGradient;
}
