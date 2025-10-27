import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

import '../../provider.dart';

class PasswordTextFormField extends ConsumerStatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final GlobalKey<FormState> globalKey;

  const PasswordTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.globalKey,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  ConsumerState<PasswordTextFormField> createState() =>
      _ReusableTextFieldState();
}

class _ReusableTextFieldState extends ConsumerState<PasswordTextFormField> {
  bool _isObscured = false;
  late Resources resources;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    resources = ref.read(resourceProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.globalKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _isObscured,
            keyboardType: widget.keyboardType,
            style: resources.themes.appStyle.black80016,
            decoration: InputDecoration(
              filled: true,
              fillColor: resources.themes.pureWhite,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              hintText: widget.hintText,
              hintStyle: resources.themes.appStyle.interBold14.copyWith(
                color: resources.themes.greyB7B7,
              ),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: resources.themes.greyB7B7,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: widget.validator,
          ),
        ),
      ),
    );
  }
}
