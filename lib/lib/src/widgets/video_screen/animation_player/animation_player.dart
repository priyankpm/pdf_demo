import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/emotion_video_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/widgets/video_screen/activity_screens/chat_screen.dart';
import 'package:whiskers_flutter_app/src/widgets/video_screen/activity_screens/sleep_screen.dart';

import '../../../common_utility/common_utility.dart';
import '../../../enum/pet_activity_enum.dart';
import '../activity_screens/eat_screen.dart';
import '../activity_screens/memory_wall_screen.dart';
import '../activity_screens/upload_image_screen.dart';
import '../utils/mock_data.dart';

class AnimationPlayer extends ConsumerStatefulWidget {
  const AnimationPlayer({required this.path, super.key});

  final String path;

  @override
  AnimationPlayerState createState() => AnimationPlayerState();
}

class AnimationPlayerState extends ConsumerState<AnimationPlayer> {
  // late FlickManager flickManager;
  // late AnimationPlayerDataManager dataManager;
  List items = mockData['items'];
  bool _pauseOnTap = true;
  double playBackSpeed = 1.0;
  bool useLocalPath = true;
  // final ValueNotifier<FoodTrayModel?> hiddenItemIndexNotifier = ValueNotifier(
  //   null,
  // );
  final ScrollController scrollController = ScrollController();
  bool isVideoProcessingDone = false;

  @override
  void initState() {
    super.initState();
    ref.read(emotionVideoProvider.notifier).init(docId: neutralToHappy);
    ref.read(emotionVideoProvider.notifier).initModel();

    // String url = items[0]['trailer_url'];
    // flickManager = FlickManager(
    //   videoPlayerController: useLocalPath
    //       ? (widget.path.startsWith('/data/')
    //             ? VideoPlayerController.file(
    //                 File(widget.path),
    //               ) // ✅ Local file from FFmpeg
    //             : VideoPlayerController.asset(widget.path)) // ✅ Asset
    //       : VideoPlayerController.networkUrl(
    //           Uri.parse(items[0]['trailer_url']),
    //         ),
    //   // onVideoEnd: () =>
    //   //     dataManager.playNextVideo(useLocalPath, Duration(seconds: 5)),
    // );
    //
    // dataManager = AnimationPlayerDataManager(flickManager, items);
  }

  @override
  void dispose() {
    ref.read(emotionVideoProvider.notifier).flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PetActivityEnum activityEnum =
        ref.watch(videoScreenActivityProvider).petCurrentState ??
        PetActivityEnum.eat;
    final EmotionVideoModel? emotionVideoModel = ref.watch(
      emotionVideoProvider,
    );

    return emotionVideoModel == null
        ? SizedBox.shrink()
        : activityEnum == PetActivityEnum.eat
        ? EatScreen(
            dataManager: ref.read(emotionVideoProvider.notifier).dataManager,
            flickManager: ref.read(emotionVideoProvider.notifier).flickManager,
            pauseOnTap: _pauseOnTap,
          )
        : activityEnum == PetActivityEnum.memoryWall
        ? MemoryWallScreen()
        : activityEnum == PetActivityEnum.chat
        ? ChatScreen()
        : activityEnum == PetActivityEnum.sleep
        ? SleepScreen(
            dataManager: ref.read(emotionVideoProvider.notifier).dataManager,
            flickManager: ref.read(emotionVideoProvider.notifier).flickManager,
            pauseOnTap: _pauseOnTap,
          )
        : UploadImageScreen();
  }
}
