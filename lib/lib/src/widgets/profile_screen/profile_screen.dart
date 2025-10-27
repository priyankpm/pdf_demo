import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/logout_model.dart';

import '../../common_utility/common_utility.dart';
import '../../logger/log_handler.dart';
import '../../provider.dart';
import '../../styles/resources.dart';
import '../common_widgets/generic_dog_paw_widget.dart';
import '../common_widgets/gradient_widget.dart';
import '../common_widgets/log_menu_screen.dart';
import '../common_widgets/profile_app_bar.dart';
import '../common_widgets/profile_option_details_widget.dart';
import '../common_widgets/profile_photo_widget.dart';
import '../common_widgets/top_dog_paw_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  late Resources res;
  late Logger logger;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    res = ref.read(resourceProvider);
    logger = ref.read(loggerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusBarHandler).setStatusBarColor(res.themes.lightOrange);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = getListOfWidgets();

    return Material(
      child: Stack(
        children: <Widget>[
          GradientWidget(
            res: res,
            child: ListView.builder(
              controller: scrollController,
              itemCount: widgets.length,
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: (context, index) => widgets[index],
            ),
          ),
          const TopDogPawWidget(),
          const GenericDogPawWidget(
            top: 157,
            left: 0,
            width: 70,
            height: 70,
            svgPath: profileDogPawMidLeftSvg,
          ),
          const GenericDogPawWidget(
            top: 430,
            left: 0,
            width: 86,
            height: 86,
            svgPath: profileDogPawDownLeftSvg,
          ),
          const GenericDogPawWidget(
            top: 340,
            left: 241,
            width: 86,
            height: 86,
            svgPath: profileDogPawMidSvg,
          ),
          const GenericDogPawWidget(
            top: 460,
            left: 150,
            width: 288,
            height: 288,
            svgPath: profileDogPawDownLeftSvg,
          ),
          const LogMenuScreen(),
        ],
      ),
    );
  }

  List<Widget> getListOfWidgets() {
    return <Widget>[
      ProfileAppBar(
        res: res,
        backArrowCallback: () {
          ref.read(navigationServiceProvider).goBack();
        },
        settingArrowCallback: () {
          ref.read(navigationServiceProvider).goBack();
        },
      ),
      SizedBox(height: 32),
      const ProfilePhotoWidget(),
      ProfileOptionDetailsWidget(
        controller: scrollController,
        favouritesCallback: () {},
        downloadCallback: () {},
        languagesCallback: () {},
        locationCallback: () {},
        subscribtionCallback: () {},
        displayCallback: () {},
        clearCacheCallback: () {},
        clearHistoryCallback: () {},
        logoutCallback: () async {
          ref
              .read(logoutScreenProvider.notifier)
              .notifyChanges(LogoutModel(showLogoutScreen: true));
        },
      ),
    ];
  }
}
