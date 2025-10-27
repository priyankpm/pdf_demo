import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common_utility/common_utility.dart';

class SwappingButtons extends StatelessWidget {
  const SwappingButtons({
    required this.leftCallback,
    required this.rightCallback,
    this.showDeleteButton = false,
    this.deleteCallback,
    super.key,
  });

  final VoidCallback leftCallback;
  final VoidCallback rightCallback;
  final bool showDeleteButton;
  final VoidCallback? deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: leftCallback,
            child: Container(
              width: 30,
              height: 63,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Center(
                child: SvgPicture.asset(
                  leftArrowSvg,
                  width: 15,
                  height: 15,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: rightCallback,
            child: Container(
              width: 30,
              height: 63,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9),
                  bottomLeft: Radius.circular(9),
                ),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Center(
                child: SvgPicture.asset(
                  rightArrowSvg,
                  width: 15,
                  height: 15,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),

        // Delete button (appears when showDeleteButton is true)
        /*if (showDeleteButton && deleteCallback != null)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Align(
              child: GestureDetector(
                onTap: deleteCallback,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),*/
      ],
    );
  }
}