// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../core/app_export.dart';

// extension TextFormFieldStyleHelper on CustomTextFormField {
//   static OutlineInputBorder get outlineGrayTL8 => OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8.h),
//         borderSide: BorderSide(
//           color: appTheme.primaryGray,
//           width: 2,
//         ),
//       );
// }

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
      this.alignment,
      this.width,
      this.boxDecoration,
      this.scrollPadding,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.textStyle,
      this.obscureText = false,
      this.readOnly = false,
      this.onTap,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.maxLength,
      this.hintText,
      this.prefixIcon,
      this.enable,
      this.suffix,
      this.suffixConstraints,
      this.formKey,
      this.inputFormatters,
      this.textCapitalization,
      this.validator,
      this.borderRadius,
      this.fillColor,
      this.hintStyle,
              this.onFocusRemoved,
        this.onCompleted,
        this.onChanged,
      })
      : super(
          key: key,
        );

  final AlignmentGeometry? alignment;

  final double? width;
  final BoxDecoration? boxDecoration;
  final TextCapitalization? textCapitalization;

  final GlobalKey<FormState>? formKey;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final bool? readOnly;
  final bool? enable;

  final VoidCallback? onTap;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;
  final int? maxLength;

  final String? hintText;
  final String? prefixIcon;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  final BorderRadius? borderRadius;

  final Color? fillColor;
  final TextStyle? hintStyle;
  final VoidCallback? onFocusRemoved;
  final VoidCallback? onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? AlignmentDirectional.center,
            child: textFormFieldWidget(context))
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          onEditingComplete: onCompleted,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
            if (onFocusRemoved != null) {
              onFocusRemoved!();
            }
          },
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.blackS16W400,
          obscureText: obscureText!,
          readOnly: readOnly!,
          enabled: enable ?? true,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          onTap: () {
            onTap?.call();
          },
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          minLines: 1,
          inputFormatters: inputFormatters,
          maxLength: maxLength ?? 500,
          decoration: (decoration ?? const InputDecoration()).copyWith(
            counterText: '', // Hide maxLength counter
          ),
          validator: validator,
          onChanged: (value) {
            // Call the custom onChanged callback if provided
            onChanged?.call(value);
            // Also validate the form if formKey is provided
            if (formKey?.currentState != null) {
              formKey!.currentState!.validate();
            }
          },
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.blackS16W400,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        errorMaxLines: 3,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.h,
          vertical: 14.h,
        ),
        fillColor: fillColor ?? appTheme.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? CustomBorderRadiusStyle.border30,
          borderSide: BorderSide(
            color: appTheme.primaryGray,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? CustomBorderRadiusStyle.border30,
          borderSide: BorderSide(
            color: appTheme.primaryGray,
            width: 1,
          ),
        ),
        focusedBorder: (OutlineInputBorder(
            borderRadius: borderRadius ?? CustomBorderRadiusStyle.border30,
            borderSide: BorderSide(
              color: appTheme.primary,
              width: 1,
            ))),
      );

  Widget? get prefix => prefixIcon != null ? Container(
        margin: EdgeInsets.fromLTRB(16.h, 14.h, 10.h, 14.h),
        child: CustomImageView(
                imagePath: prefixIcon,
                height: 20.h,
                color: appTheme.primary,
                width: 20.h,
                fit: BoxFit.contain,
              ),
      ) : null ;

  BoxConstraints get prefixConstraints => BoxConstraints(
        maxHeight: 48.h,
      );
}
