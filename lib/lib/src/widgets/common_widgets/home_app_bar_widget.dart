import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';

class HomeAppBarWidget extends ConsumerWidget {
  const HomeAppBarWidget({
    required this.settingsCallback,
    required this.speakerCallback,
    super.key,
  });

  final VoidCallback settingsCallback;
  final VoidCallback speakerCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources resources = ref.read(resourceProvider);
    final bool showMuteIcon =
        ref.watch(speakerStateProvider).showMuteIcon ?? false;
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: Row(
        children: <Widget>[
          SizedBox(width: 13),
          GestureDetector(
            onTap: speakerCallback,
            child: SizedBox(
              width: 28,
              height: 28,
              child: SvgPicture.asset(
                showMuteIcon ? speakerMuteSvg : speakerSvg,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  resources.themes.boldGrey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 115),
          SizedBox(
            height: 28,
            child: Text(
              livingRoomString,
              style: resources.themes.appStyle.interBold120,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: settingsCallback,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  settingsSvg,
                  width: 37,
                  height: 37,
                  colorFilter: ColorFilter.mode(
                    resources.themes.boldGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
