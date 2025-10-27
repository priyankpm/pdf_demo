import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common_utility/common_utility.dart';

class BackgroundPaws extends StatelessWidget {
  final Widget child;
  const BackgroundPaws({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Transform.rotate(
            angle: 0.5,
            child: SvgPicture.asset(
              pawSvg,
              width: 200,
              height: 200,
              colorFilter: const ColorFilter.mode(Color(0x1A935B00), BlendMode.srcIn),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Transform.rotate(
            angle: -0.5,
            child: SvgPicture.asset(
              pawSvg,
              width: 200,
              height: 200,
              colorFilter: const ColorFilter.mode(Color(0x1A935B00), BlendMode.srcIn),
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
