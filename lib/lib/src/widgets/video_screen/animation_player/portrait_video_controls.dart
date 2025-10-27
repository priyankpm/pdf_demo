import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';
import 'data_manager.dart';

class AnimationPlayerPortraitVideoControls extends StatelessWidget {
  const AnimationPlayerPortraitVideoControls({
    Key? key,
    this.pauseOnTap,
    this.dataManager,
  }) : super(key: key);
  final bool? pauseOnTap;
  final AnimationPlayerDataManager? dataManager;

  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);

    return Container(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250), // faster for smoother feel
        transitionBuilder: (child, animation) {
          // 👇 Changed from SlideTransition to FadeTransition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Container(
          key: ObjectKey(
            flickVideoManager.videoPlayerController,
          ),
          // margin: EdgeInsets.all(10),
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(10),
            child: FlickVideoWithControls(
              willVideoPlayerControllerChange: false,
              playerLoadingFallback: Positioned.fill(
                child: Image.asset(
                  dataManager!.getCurrentPoster(),
                  fit: BoxFit.cover,
                ),
              ),
              controls: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: IconTheme(
                  data: IconThemeData(color: Colors.white, size: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: pauseOnTap!
                            ? FlickTogglePlayAction(
                                child: FlickSeekVideoAction(
                                  child: Center(child: SizedBox.shrink()),
                                ),
                              )
                            : FlickToggleSoundAction(
                                child: FlickSeekVideoAction(
                                  child: Center(child: SizedBox.shrink()),
                                ),
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlickAutoHideChild(
                            autoHide: false,
                            showIfVideoNotInitialized: false,
                            // child: FlickSoundToggle(),
                            child: Container(),
                          ),
                          FlickAutoHideChild(
                            autoHide: false,
                            showIfVideoNotInitialized: false,
                            // child: FlickFullScreenToggle(),
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
