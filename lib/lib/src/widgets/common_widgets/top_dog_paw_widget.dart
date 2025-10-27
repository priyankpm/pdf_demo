import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common_utility/common_utility.dart';

class TopDogPawWidget extends StatelessWidget {
  const TopDogPawWidget({this.color,super.key});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -17,
      left: 150,
      child: IgnorePointer(
        child: SvgPicture.asset(
          dogPaw,
          width: 277.81,
          height: 288.10,
          colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
