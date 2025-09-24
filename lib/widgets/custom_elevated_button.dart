// Flutter imports:
import 'package:baseproject/theme/custom_button_style.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../core/app_export.dart';
import 'base_button.dart';

enum CSButtonType {
  fill,
  border
}

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsetsGeometry? margin,
    VoidCallback? onPressed,
    AlignmentGeometry? alignment,
    // TextStyle? buttonTextStyle,
    double? height,
    double? width,
    required String text,
    this.buttonState = ButtonState.normal,
    this.csButtonType = CSButtonType.fill
    // this.buttonStyles,
  }) : super(
         text: text,
         onPressed: onPressed,
         // buttonStyle: buttonStyle,
         buttonState: buttonState,
         // buttonTextStyle: buttonTextStyle,
         height: height,
         width: width,
         alignment: alignment,
         margin: margin,
       );

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final ButtonState buttonState;

  final CSButtonType csButtonType;

  @override
  Widget build(BuildContext context) {
    return buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => GestureDetector(
    onTap: () async {
      onTap();
    },
    child: AnimatedContainer(
      key: Key(text),
      height:
          buttonState == ButtonState.loading ? 56.0.h : this.height ?? 56.0.h,
      width:
          buttonState == ButtonState.loading ? 56.0.h : this.width ?? 150.0.h,
      // color: appTheme.primary,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration:
          buttonState == ButtonState.disabled
              ? CustomButtonStyles.fillPrimaryGrayTL12
              : csButtonType == CSButtonType.border ? CustomButtonStyles.borderPrimaryTL12 : CustomButtonStyles.fillPrimaryTL12,
      child: _buttonBody(),
    ),
  );

  Widget get loadingWidget => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>( csButtonType == CSButtonType.border ? appTheme.primary : appTheme.white),
          strokeWidth: 2.5,
          strokeCap: StrokeCap.round,
        ),
      ),
    ],
  );

  void onTap() {
    if (buttonState == ButtonState.disabled ||
        buttonState == ButtonState.loading) {
      return;
    } else {
      if (onPressed != null) {
        onPressed!();
      }
    }
  }

  Widget _buttonBody() {
    return buttonState == ButtonState.loading
        ? loadingWidget
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10.h,
          children: [
            leftIcon ?? SizedBox(),
            Flexible(child: Text(text, style: csButtonType == CSButtonType.border ? CustomTextStyles.primaryS18W600 : CustomTextStyles.whiteS18W600)),
            rightIcon ?? SizedBox(),
          ],
        );
  }
}
