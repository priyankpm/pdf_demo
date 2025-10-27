import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:whiskers_flutter_app/src/models/activity_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/viewmodel/video/gif_controller.dart';
import 'package:whiskers_flutter_app/src/widgets/report/feedback_dialog.dart';
import '../../common_utility/background_remover.dart';
import '../../common_utility/common_utility.dart';
import '../../enum/pet_activity_enum.dart';
import '../../models/count_sheep_model.dart';
import '../../models/video_bottom_bar_model.dart';
import '../common_widgets/back_button.dart';
import '../common_widgets/count_sheep_screen.dart';
import 'animation_player/animation_player.dart';
import '../common_widgets/video_bottom_navigation_bar.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends ConsumerState<VideoScreen> {
  final List<Map<String, dynamic>> samples = <Map<String, dynamic>>[
    {
      'name': 'cat 1',
      'widget':
          '/data/user/0/com.onesol.pet.whiskers_flutter_app/cache/output_1756231186552.mp4',
    },
    // {
    //   'name': 'dog 1',
    //   'widget': dog1Video,
    // },
    // {
    //   'name': 'dog 2',
    //   'widget': dog2Video,
    // },
    // {
    //   'name': 'dog 3',
    //   'widget': dog3Video,
    // },
  ];

  late Resources res;

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    // removeBackground();
  }

  Future<String> removeBackground() async {
    final processed = await BackgroundRemover.replaceGreenScreen(
      inputAsset: neutralToHappy,
      backgroundAsset: cat1IMG,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        samples.add({'name': 'cat 1', 'widget': processed?.path});
      });
    });
    return processed?.path ?? '';
  }

  int selectedIndex = 0;

  void changeSample(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final PetActivityEnum activityEnum =
        ref.watch(videoScreenActivityProvider).petCurrentState ??
        PetActivityEnum.uploadImage;
    final PetActivityEnum previousActivityEnum =
        ref.watch(videoScreenActivityProvider).previousPetState ??
        PetActivityEnum.none;

    final videoController = ref.watch(videoControllerProvider);

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: activityEnum == PetActivityEnum.chat
              ? const SizedBox.shrink()
              : VideoBottomNavigationBar([
                  VideoBottomBarModel(pawVideoSvg, () {
                    bottomTabsCallback(
                      PetActivityEnum.uploadImage,
                      activityEnum,
                    );
                  }, PetActivityEnum.uploadImage),
                  VideoBottomBarModel(chattingVideoSvg, () {
                    bottomTabsCallback(PetActivityEnum.chat, activityEnum);
                  }, PetActivityEnum.chat),
                  VideoBottomBarModel(mealVideoSvg, () {
                    bottomTabsCallback(PetActivityEnum.eat, activityEnum);
                  }, PetActivityEnum.eat),
                  VideoBottomBarModel(cloudVideoSvg, () {
                    bottomTabsCallback(PetActivityEnum.sleep, activityEnum);
                  }, PetActivityEnum.sleep),
                  VideoBottomBarModel(memoryWallVideoSvg, () {
                    bottomTabsCallback(
                      PetActivityEnum.memoryWall,
                      activityEnum,
                    );
                  }, PetActivityEnum.memoryWall),
                ]),
          appBar: AppBar(
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            backgroundColor: res.themes.appbarColor,
            title: Text(
              PetActivityEnum.none == activityEnum
                  ? previousActivityEnum.name
                  : activityEnum.name,
              style: res.themes.appStyle.black50015,
            ),
            toolbarHeight: 72,
            // leadingWidth: 30,
            // leading: GestureDetector(
            //   onTap: () {
            //     bottomTabsCallback(
            //       previousActivityEnum,
            //       PetActivityEnum.none,
            //     );
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 12.0),
            //     child: SizedBox(
            //       width: 30,
            //       child: Iconify(Ic.baseline_less_than),
            //     ),
            //   ),
            // ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: commonBackButton(
                context,
                onPressed: () {
                  bottomTabsCallback(
                    previousActivityEnum,
                    PetActivityEnum.none,
                  );
                },
              ),
            ),

            actions: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         FeedbackDialog(isFullScreen: true),
                  //   ),
                  // );

                  String assetPath =
                      (activityEnum == PetActivityEnum.eat ||
                          activityEnum == PetActivityEnum.sleep)
                      ? videoController.currentGifPath
                      : "";
                  showDialog(
                    context: context,
                    builder: (context) => FeedbackDialog(
                      screeName: activityEnum.name,
                      asset: activityEnum.name,
                      assetPath: assetPath,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    width: 30,
                    child: Iconify(Ic.baseline_warning_amber),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(246, 245, 250, 1),
          body: samples.isNotEmpty
              ? _buildMobileView(activityEnum)
              : SizedBox.shrink(),
        ),
        const CountSheepScreen(),
      ],
    );
  }

  void bottomTabsCallback(
    PetActivityEnum newActivity,
    PetActivityEnum previousActivity,
  ) {
    ref
        .read(videoScreenActivityProvider.notifier)
        .notifyChanges(
          ActivityModel(
            petCurrentState: newActivity,
            previousPetState: previousActivity,
          ),
        );
  }

  Widget _buildMobileView(PetActivityEnum activityEnum) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: (PointerUpEvent event) {
        if (activityEnum == PetActivityEnum.sleep) {
          ref
              .read(countSheepProvider.notifier)
              .notifyChanges(
                CountSheepModel(showCountSheepScreen: true, sheepCount: 0),
              );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: AnimationPlayer(path: samples[selectedIndex]['widget']),
          ),
        ],
      ),
    );
  }
}
