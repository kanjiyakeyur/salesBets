// Flutter imports:
import 'package:flutter/material.dart';
import 'package:baseproject/widgets/base_button.dart';

// Project imports:
import '../core/app_export.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillBlack => BoxDecoration(
        color: appTheme.black,
        borderRadius: CustomBorderRadiusStyle.border30,
      );

  static BoxDecoration get fillGray => BoxDecoration(
    color: appTheme.lightGray,
    borderRadius: CustomBorderRadiusStyle.border30,
  );

  static BoxDecoration get fillPrimaryB50 => BoxDecoration(
    color: appTheme.primary,
    borderRadius: CustomBorderRadiusStyle.border50,
  );


  static BoxDecoration get none => BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
  CustomIconButton(
      {Key? key,
      this.alignment,
      this.height,
      this.width,
      this.decoration,
      this.padding,
      this.onTap,
      this.buttonState = ButtonState.normal,
      this.child})
      : super(
          key: key,
        );

  final AlignmentGeometry? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Widget? child;

  ButtonState? buttonState;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: iconButtonWidget)
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => Container(
    height: height ?? 0,
    width: width ?? 0,
    decoration: decoration ?? ((buttonState == ButtonState.disabled) ? IconButtonStyleHelper.fillGray :  IconButtonStyleHelper.fillBlack),
    child: IconButton(
      color: Colors.red,
      padding: padding ?? EdgeInsetsDirectional.zero,
      onPressed: buttonState == ButtonState.disabled ? null : onTap,
      icon: child ?? Container(),
    ),
  );
}
