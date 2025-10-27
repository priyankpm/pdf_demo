import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/models/logout_model.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';
import 'gradient_widget.dart';

class LogMenuScreen extends ConsumerWidget {
  const LogMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources res = ref.read(resourceProvider);

    final bool showLogoutScreen =
        ref.watch(logoutScreenProvider).showLogoutScreen ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showLogoutScreen) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: res.themes.lightOrange,
          ),
        );
      } else {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: res.themes.transparent,
          ),
        );
      }
    });

    return showLogoutScreen
        ? GestureDetector(
            onTap: () {
              closeLogoutScreen(ref);
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color.fromRGBO(0, 0, 0, 0.3),
                      Color.fromRGBO(0, 0, 0, 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: GradientWidget(
                    res: res,
                    width: 366,
                    height: 168,
                    showBorderRadius: true,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              areYouSureString,
                              style: res.themes.appStyle.black60010,
                            ),
                            SizedBox(height: 20),
                            Text(
                              loggingOutMayRequire,
                              style: res.themes.appStyle.black50015,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      closeLogoutScreen(ref);
                                    },
                                    child: Container(
                                      width: 130,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          cancelString,
                                          style: res.themes.appStyle.black50015
                                              .copyWith(
                                                color: res.themes.darkBrown,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      closeLogoutScreen(ref);
                                    },
                                    child: Container(
                                      width: 130,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: res.themes.darkBrown,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return LinearGradient(
                                              colors: <Color>[
                                                res.themes.lightOrange,
                                                res.themes.darkOrange,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ).createShader(bounds);
                                          },
                                          blendMode: BlendMode.srcIn,
                                          child: Text(
                                            logoutWordString,
                                            style: res
                                                .themes
                                                .appStyle
                                                .white70016
                                                .copyWith(
                                                  color: res.themes.darkOrange,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
                            child: Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: res.themes.pureWhite,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close, // Replace with desired icon
                                  size: 16, // Adjust size based on padding
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  void closeLogoutScreen(WidgetRef ref) {
    ref
        .read(logoutScreenProvider.notifier)
        .notifyChanges(LogoutModel(showLogoutScreen: false));
  }
}
