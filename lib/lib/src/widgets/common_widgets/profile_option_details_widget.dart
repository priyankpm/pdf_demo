import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';

class ProfileOptionDetailsWidget extends ConsumerWidget {
  const ProfileOptionDetailsWidget({
    required this.controller,
    required this.favouritesCallback,
    required this.downloadCallback,
    required this.languagesCallback,
    required this.locationCallback,
    required this.subscribtionCallback,
    required this.displayCallback,
    required this.clearCacheCallback,
    required this.clearHistoryCallback,
    required this.logoutCallback,
    super.key,
  });

  final ScrollController controller;
  final VoidCallback favouritesCallback;
  final VoidCallback downloadCallback;
  final VoidCallback languagesCallback;
  final VoidCallback locationCallback;
  final VoidCallback subscribtionCallback;
  final VoidCallback displayCallback;
  final VoidCallback clearCacheCallback;
  final VoidCallback clearHistoryCallback;
  final VoidCallback logoutCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources resources = ref.read(resourceProvider);
    final String version = ref.read(packageVersionUtilProvider).fullVersion;

    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.only(left: 23, right: 48),
        child: Column(
          children: <Widget>[
            ProfileSectionWidget(
              resources,
              MdiIcons.heartOutline,
              favouritesString,
              favouritesCallback,
              svgPath: favouriteSvg,
            ),
            ProfileSectionWidget(
              resources,
              Icons.file_download_outlined,
              downloadsString,
              downloadCallback,
              svgPath: downloadSvg,
            ),
            const ProfileBorderWidget(),
            ProfileSectionWidget(
              resources,
              MdiIcons.web,
              languagesString,
              languagesCallback,
              svgPath: languageSvg,
            ),
            ProfileSectionWidget(
              resources,
              MdiIcons.locationEnter,
              locationString,
              locationCallback,
              svgPath: locationSvg,
            ),
            ProfileSectionWidget(
              resources,
              MdiIcons.play,
              subscribtionString,
              subscribtionCallback,
              svgPath: subsSvg,
            ),
            ProfileSectionWidget(
              resources,
              Icons.display_settings,
              displayString,
              displayCallback,
              svgPath: displaySvg,
            ),
            const ProfileBorderWidget(),
            ProfileSectionWidget(
              resources,
              Icons.delete_outline,
              clearCacheString,
              clearCacheCallback,
              svgPath: clearCachetSvg,
            ),
            ProfileSectionWidget(
              resources,
              Icons.circle_outlined,
              clearHistoryString,
              clearHistoryCallback,
              svgPath: clearHistorySvg,
            ),
            ProfileSectionWidget(
              resources,
              Icons.login_outlined,
              logOutString,
              logoutCallback,
              svgPath: logoutSvg,
            ),
            const ProfileBorderWidget(),
            AppVersionWidget(resources, version),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProfileBorderWidget extends StatelessWidget {
  const ProfileBorderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 27.95, top: 32),
      width: 341.0581,
      height: 0, // No height, just a border
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
    );
  }
}

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget(this.resources, this.version, {super.key});

  final Resources resources;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Center(
        child: Text(
          '$appVersionString $version',
          style: resources.themes.appStyle.black50010,
        ),
      ),
    );
  }
}

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget(
    this.res,
    this.iconData,
    this.text,
    this.callback, {
    this.svgPath = '',
    super.key,
  });

  final Resources res;
  final IconData iconData;
  final String text;
  final String? svgPath;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: GestureDetector(
        onTap: callback,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 25,
              height: 25,
              child: svgPath?.isNotEmpty ?? false
                  ? SvgPicture.asset(svgPath ?? "", width: 25, height: 25)
                  : Icon(iconData, size: 25, color: Colors.black),
            ),
            SizedBox(width: 44),
            SizedBox(
              height: 18,
              child: Text(text, style: res.themes.appStyle.black50015),
            ),
            const Spacer(),
            SizedBox(
              width: 15,
              child: Iconify(Ic.baseline_greater_than),
            ),
          ],
        ),
      ),
    );
  }
}
