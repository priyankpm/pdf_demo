import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';

class HomeScreenDogPawWidget extends StatelessWidget {
  const HomeScreenDogPawWidget(this.resources,{super.key});
  final Resources resources;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 40,
          child: IgnorePointer(
            child: SvgPicture.asset(
              homeDogPawLeft,
              width: 82,
              height: 82,
              colorFilter: ColorFilter.mode(
                resources.themes.yellowBrownMix,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IgnorePointer(
            child: SvgPicture.asset(
              homeDogPawRight,
              width: 82,
              height: 82,
              colorFilter: ColorFilter.mode(
                resources.themes.yellowBrownMix,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
