import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whiskers_flutter_app/src/styles/resources.dart';

class GradientWidget extends StatefulWidget {
  const GradientWidget({
    required this.child,
    required this.res,
    this.height,
    this.width,
    this.colors,
    this.showBorderRadius = false,
    super.key,
  });

  final Widget child;
  final Resources res;
  final double? width;
  final double? height;
  final bool? showBorderRadius;
  final List<Color>? colors;

  @override
  State<GradientWidget> createState() => _GradientWidgetState();
}

class _GradientWidgetState extends State<GradientWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? MediaQuery.of(context).size.height,
      decoration: getBoxDecoration(),
      child: widget.child,
    );
  }

  BoxDecoration getBoxDecoration() {
    return widget.showBorderRadius ?? false
        ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.colors  ?? [
                widget.res.themes.lightOrange,
                widget.res.themes.darkOrange,
              ],
            ),
            border: Border.all(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(16),
          )
        : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.colors  ?? [
                widget.res.themes.lightOrange,
                widget.res.themes.darkOrange,
              ],
            ),
          );
  }
}
