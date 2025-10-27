import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

import '../../common_utility/common_utility.dart';
import '../../styles/resources.dart';
import 'back_button.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    required this.res,
    required this.backArrowCallback,
    required this.settingArrowCallback,
    super.key,
  });

  final Resources res;
  final VoidCallback backArrowCallback;
  final VoidCallback settingArrowCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, top: 37),
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // GestureDetector(
            //   onTap: backArrowCallback,
            //   child: SizedBox(width: 30, child: Iconify(Ic.baseline_less_than)),
            // ),
            commonBackButton(context, onPressed: backArrowCallback,),
            SizedBox(width: 107),
            Text(myProfileString, style: res.themes.appStyle.interBold120),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: res.themes.blackPure,
                ),
                onPressed: settingArrowCallback,
              ),
            ),
            SizedBox(width: 32),
          ],
        ),
      ),
    );
  }
}
