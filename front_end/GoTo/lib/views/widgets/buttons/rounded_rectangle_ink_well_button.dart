import 'package:flutter/material.dart';

class RoundedRectangleInkWellButton extends StatelessWidget {
  final Widget child;
  final double? width, height;
  final GestureTapCallback? onTap;
  final Color? splashColor;
  final ShapeBorder? customBorder;
  final LinearGradient? bgLinearGradient;
  final Color? bgColor;
  final double borderRadiusValue;
  final double? paddingVertical;
  final Alignment alignment;

  const RoundedRectangleInkWellButton({
    super.key, this.onTap, required this.child,
    this.width, this.height,
    this.splashColor = Colors.white38,
    this.customBorder,
    this.bgLinearGradient,
    this.bgColor,
    this.borderRadiusValue = 8,
    this.paddingVertical,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        gradient: bgLinearGradient,
        color: (bgLinearGradient == null) ? (bgColor ?? Colors.white) : null,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: customBorder ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
          ),
          splashColor: splashColor,
          child: Container(
            alignment: alignment,
            width: width, height: height,
            padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 0),
            child: child,
          ),
        ),
      ),
    );
  }
}