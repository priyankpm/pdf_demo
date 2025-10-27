import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../logger/log_handler.dart';
import '../../models/speaker_model.dart';
import '../common_widgets/home_app_bar_widget.dart';
import '../common_widgets/home_screen_bottom_navigator.dart';
import '../common_widgets/home_screen_dog_paw_widget.dart';
import '../common_widgets/swapping_buttons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late Resources resources;
  late Logger logger;
  final TextEditingController textEditingController = TextEditingController();
  final GlobalKey<FormState> textGlobalKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    resources = ref.read(resourceProvider);
    logger = ref.read(loggerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(resources.themes.paleYellow);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = getListOfWidgets();

    return Material(
      color: resources.themes.paleYellow,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView.builder(
              controller: scrollController,
              itemCount: widgets.length,
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: (context, index) => widgets[index],
            ),
            HomeScreenDogPawWidget(resources),
            HomeScreenBottomNavigator(
              resources,
              textGlobalKey,
              textEditingController,
              () {
                logger.d('dog paw callback');
              },
              () {
                logger.d('micro phone callback');
              },
              scrollController,
            ),
            SwappingButtons(leftCallback: () {}, rightCallback: () {}),
          ],
        ),
      ),
    );
  }

  List<Widget> getListOfWidgets() {
    return <Widget>[
      HomeAppBarWidget(
        speakerCallback: () {
          logger.d('speakerCallback');
          final bool showMuteIcon = ref
              .read(speakerStateProvider.notifier)
              .showMuteIcon();
          ref
              .read(speakerStateProvider.notifier)
              .notifyChanges(SpeakerModel(showMuteIcon: !showMuteIcon));
        },
        settingsCallback: () {
          logger.d('settingsCallback');
        },
      ),
    ];
  }
}
