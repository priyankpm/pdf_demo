import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FramedPicture extends StatelessWidget {
  final String pictureUrl;
  final String frameAsset; // png or svg
  final double size; // flexible size

  const FramedPicture({
    super.key,
    required this.pictureUrl,
    required this.frameAsset,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Picture
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // optional
            child: Image.network(
              pictureUrl,
              width: size * 0.85,
              height: size * 0.85,
              fit: BoxFit.cover,
            ),
          ),

          // Frame overlay (can be PNG or SVG)
          Positioned.fill(
            child: frameAsset.endsWith('.svg')
                ? SvgPicture.asset(frameAsset, fit: BoxFit.fill)
                : Image.asset(frameAsset, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  }
}
