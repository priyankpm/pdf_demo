import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../logger/log_handler.dart';
import 'res/app_dimens.dart';
import 'utils/app_pixels.dart';
import 'utils/app_theme_mode.dart';

import 'res/app_mdl_strings.dart';
import 'res/app_strings.dart';
import 'res/app_themes.dart';

/// class to define and hold the instances for all resources
class Resources {
  Resources(this.ref, this._isLightMode, {Logger? logger});

  final Ref<dynamic> ref;
  final AppThemeMode _isLightMode;
  AppDimens dimen = AppDimens();

  AppThemes get themes => AppThemes(_isLightMode, appPixels);
  AppStrings string = AppStrings();
  AppPixels appPixels = AppPixels();
  AppMdlStrings mdlString = AppMdlStrings();
}
