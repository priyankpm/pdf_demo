import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';

class SignUpWidget extends ConsumerWidget {
  const SignUpWidget({
    super.key,
    required this.onSignUpPressed,
    this.onJoinNowPressed,
    this.isLoading = false,
    this.buttonWidth = 229,
    this.buttonHeight = 47,
    this.verticalPadding = 20,
    this.horizontalPadding = 20,
    this.spacing = 30,
  });

  final VoidCallback onSignUpPressed;
  final VoidCallback? onJoinNowPressed;
  final bool isLoading;
  final double buttonWidth;
  final double buttonHeight;
  final double verticalPadding;
  final double horizontalPadding;
  final double spacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources resources = ref.read(resourceProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Center(
        child: Column(
          children: [
            // Sign Up Button
            _buildSignUpButton(resources),
            SizedBox(height: spacing),

            // Already have an account section
            _buildAccountSection(resources),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton(Resources resources) {
    return GestureDetector(
      onTap: isLoading ? null : onSignUpPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 210, 136, 0.5), // rgba(255,210,136,0.5)
              Color.fromRGBO(177, 86, 0, 0.5),   // rgba(177,86,0,0.5)
            ],
          ),          borderRadius: BorderRadius.circular(14),
        ),
        child: TextButton(
          onPressed: isLoading ? null : onSignUpPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 85,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? _buildLoadingIndicator()
              : _buildButtonText(resources),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildButtonText(Resources resources) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            resources.themes.lightOrange,
            resources.themes.darkOrange,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        signUpString,
        style: resources.themes.appStyle.white70016.copyWith(
          color: resources.themes.darkOrange,
        ),
      ),
    );
  }

  Widget _buildAccountSection(Resources resources) {
    return SizedBox(
      width: 318,
      height: 17,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            alreadyHaveAnAccountString,
            style: resources.themes.appStyle.black30015,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onJoinNowPressed,
            child: Text(
              joinNowString,
              style: resources.themes.appStyle.black70014.copyWith(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}