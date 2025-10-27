import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/reuseablke_text_form.dart';

import '../../common_utility/common_utility.dart';

class HomeScreenBottomNavigator extends StatelessWidget {
  const HomeScreenBottomNavigator(
    this.resources,
    this.textGlobalKey,
    this.textEditingController,
    this.dogPawCallback,
    this.microphoneCallback,
    this.scrollController, {
    super.key,
  });

  final Resources resources;
  final GlobalKey<FormState> textGlobalKey;
  final ScrollController scrollController;
  final TextEditingController textEditingController;
  final VoidCallback dogPawCallback;
  final VoidCallback microphoneCallback;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Row(
        children: <Widget>[
          SizedBox(width: 13),
          GestureDetector(
            onTap: dogPawCallback,
            child: SizedBox(
              width: 28,
              height: 28,
              child: SvgPicture.asset(
                pawSvg,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  resources.themes.boldGrey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 13),
          SizedBox(
            width: 285,
            height: 35,
            child: ReusableTextField(
              globalKey: textGlobalKey,
              hintText: chatString,
              controller: textEditingController,
              keyboardType: TextInputType.name,
              validator: (value) {
                return null;
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: microphoneCallback,
              child: Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  microphoneSvg,
                  width: 37,
                  height: 37,
                  colorFilter: ColorFilter.mode(
                    resources.themes.boldGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
