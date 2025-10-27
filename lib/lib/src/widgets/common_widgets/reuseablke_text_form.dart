import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider.dart';
import '../../styles/resources.dart';

class ReusableTextField extends ConsumerWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final GlobalKey<FormState> globalKey;
  final Color? hintStyleColor;
  final Color? fillColor;
  final TextStyle? style;
  final EdgeInsets? padding;

  const ReusableTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.globalKey,
    this.validator,
    this.obscureText = false,
    this.hintStyleColor,
    this.fillColor,
    this.style,
    this.padding,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Resources resources = ref.read(resourceProvider);

    return Form(
      key: globalKey,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: style ?? resources.themes.appStyle.black80016,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor ?? resources.themes.pureWhite,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              hintText: hintText,
              hintStyle: resources.themes.appStyle.interBold14.copyWith(
                color: hintStyleColor ?? resources.themes.greyB7B7,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}
