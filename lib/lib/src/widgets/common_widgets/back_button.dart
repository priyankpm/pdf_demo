
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common_utility/common_utility.dart';

Widget commonBackButton(BuildContext context, {void Function()? onPressed}) {
  return IconButton(
    icon: SvgPicture.asset(backImageSvgPath),
    onPressed: onPressed ?? () => Navigator.pop(context),
  );
}
