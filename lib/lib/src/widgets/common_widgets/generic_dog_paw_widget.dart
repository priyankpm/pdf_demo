import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common_utility/common_utility.dart';

class GenericDogPawWidget extends StatelessWidget {
  const GenericDogPawWidget({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
    required this.svgPath,
    super.key,
  });

  final double top;
  final double left;
  final double width;
  final double height;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: IgnorePointer(
        child: SvgPicture.asset(
          svgPath,
          width: width,
          height: height,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
