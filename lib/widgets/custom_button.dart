import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:army_book/utils/index.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final double constraints;
  final double iconSize;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;

  const CustomButton({
    Key? key,
    this.constraints: 20,
    this.iconSize: 10,
    this.radius: 7,
    this.icon,
    this.tooltip,
    this.onPressed,
    this.backgroundColor: bgColor,
    this.iconColor: Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return IconButton(
        tooltip: tooltip,
        splashRadius: 3,
        padding: EdgeInsets.zero,
        iconSize: sy(constraints),
        icon: Material(
          elevation: 2,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          color: backgroundColor,
          child: Container(
            height: sy(constraints),
            width: sy(constraints),
            // decoration: BoxDecoration(
            //   color: backgroundColor,
            //   borderRadius: BorderRadius.all(
            //     Radius.circular(radius),
            //   ),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.5),
            //       spreadRadius: 1,
            //       blurRadius: 1,
            //     ),
            //   ],
            // ),
            child: Icon(
              icon,
              color: iconColor,
              size: sy(iconSize),
            ),
          ),
        ),
        onPressed: onPressed,
      );
    });
  }
}
