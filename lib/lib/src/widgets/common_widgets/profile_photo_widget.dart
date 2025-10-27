import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';

class ProfilePhotoWidget extends ConsumerWidget {
  const ProfilePhotoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources res = ref.read(resourceProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 40,),
      child: SizedBox(
        height: 113,
        child: Row(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  // Profile SVG in center
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  // Camera icon outside bottom-right
                  Positioned(
                    top: 45,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 55),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent, // or any background you want
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 36),
            Container(
              height: 113,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Tina Davis',
                      style: res.themes.appStyle.black50025,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Tdavis@gmailcom',
                      style: res.themes.appStyle.black50015,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: 94,
                    height: 23,
                    decoration: BoxDecoration(
                      color: res.themes.darkBrown, // Change as per your theme
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        editProfileString, // Replace with actual content
                        style: res.themes.appStyle.black50015.copyWith(
                          color: res.themes.lightYellow,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
