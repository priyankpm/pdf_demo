import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/provider.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../common_utility/common_utility.dart';

class TermsAndConditionWidget extends ConsumerWidget {
  const TermsAndConditionWidget(this.voidCallback, {super.key});

  final BoolCallback voidCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources resources = ref.read(resourceProvider);
    final bool checkBoxTicked =
        ref.watch(termsAndConditionProvider).isTermsAccepted ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => voidCallback(!checkBoxTicked),
            child: Icon(
              checkBoxTicked
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: resources.themes.greyB7B7,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "I agree to the ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: "Terms & Conditions",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: Navigate to Terms page
                      },
                  ),
                  const TextSpan(
                    text: " and ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: Navigate to Privacy page
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

typedef BoolCallback = void Function(bool);
