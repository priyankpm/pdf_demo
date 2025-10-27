import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/enum/pet_activity_enum.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../models/video_bottom_bar_model.dart';

class VideoBottomNavigationBar extends ConsumerWidget {
  const VideoBottomNavigationBar(this.models, {super.key});

  final List<VideoBottomBarModel> models;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources resources = ref.read(resourceProvider);
    final PetActivityEnum currentPetActivityEnum =
        ref.watch(videoScreenActivityProvider).petCurrentState ??
        PetActivityEnum.none;

    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Container(
        height: 72,
        color: resources.themes.appbarColor,
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            models.length,
            (int index) => getActivityWidget(
              models[index],
              currentPetActivityEnum,
              resources,
            ),
          ),
        ),
      ),
    );
  }

  Widget getActivityWidget(
    VideoBottomBarModel model,
    PetActivityEnum currentPetActivityEnum,
    Resources resources,
  ) {
    final bool isItemSelected = model.petActivityEnum == currentPetActivityEnum;

    return GestureDetector(
      onTap: model.callback,
      child: SizedBox(
        height: 25,
        width: 25,
        child: SvgPicture.asset(
          model.path,
          colorFilter: ColorFilter.mode(
            isItemSelected
                ? resources.themes.bottomBarVideoColor
                : resources.themes.blackPure,
            BlendMode.srcIn, // replaces SVG color
          ),
        ),
      ),
    );
  }
}
