import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';

class SignUpSocials extends ConsumerWidget {
  const SignUpSocials(
    this.googleCallback,
    this.appleCallback,
    this.facebookCallback, {
    super.key,
  });

  final VoidCallback googleCallback;
  final VoidCallback appleCallback;
  final VoidCallback facebookCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources resources = ref.read(resourceProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        width: 335,
        // height: 93,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "Or sign up with" Text
            Center(
              child: Container(
                width: 318,
                height: 29,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                alignment: Alignment.center,
                child: Text(
                  signUpWithString,
                  style: resources.themes.appStyle.black30015,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Row of Social Buttons
            SizedBox(
              width: 318,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _socialButton(googleLogoSvg, resources, googleCallback),
                  _socialButton(appleLogoSvg, resources, appleCallback),
                  _socialButton(facebookLogoSvg, resources, facebookCallback),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(
    String assetPath,
    Resources resources,
    VoidCallback callback,
  ) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 64,
        height: 48,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 210, 136, 0.5), // rgba(255,210,136,0.5)
              Color.fromRGBO(177, 86, 0, 0.5),   // rgba(177,86,0,0.5)
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SvgPicture.asset(assetPath, fit: BoxFit.contain,color: Colors.black,width: 50,height: 50,),
      ),
    );
  }
}
