// Flutter imports:
import 'package:flutter/material.dart';

enum ButtonState {
  normal,
  loading,
  disabled,
}

class BaseButton extends StatelessWidget {
  BaseButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.buttonStyle,
      this.buttonTextStyle,
      this.buttonState,
      this.height,
      this.width,
      this.margin,
      this.alignment})
      : super(
          key: key,
        );

  final String text;

  final VoidCallback? onPressed;

  final ButtonStyle? buttonStyle;

  final TextStyle? buttonTextStyle;

  final ButtonState? buttonState;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
