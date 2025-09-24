// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';

extension on TextStyle {
  TextStyle get roboto {
    return copyWith(fontFamily: 'Roboto');
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style

  static TextStyle get _mainFontFamily => GoogleFonts.robotoSerif().copyWith(
    color: appTheme.primary,
    fontSize: 10.fSize,
    fontWeight: FontWeight.w500, // Medium
  );

  static TextStyle get buttonWhite => _mainFontFamily.copyWith(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.white,
  );

  static TextStyle get buttonPrimary => _mainFontFamily.copyWith(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.primary,
  );

  static TextStyle get bodyText => _mainFontFamily.copyWith(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.black,
  );

  // logo
  static TextStyle get logoText => _mainFontFamily.copyWith(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w500, // Bold
    color: appTheme.primary,
  );

  // onboarding Title
  static TextStyle get blackS28W600 => _mainFontFamily.copyWith(
    fontSize: 28.fSize,
    fontWeight: FontWeight.w600, // Semi-Bold
    color: appTheme.black,
  );

  // onboarding description


  // questionnaire title
  static get blackS24W500 => _mainFontFamily.copyWith(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.black,
  );

  static get blackS24W600 => _mainFontFamily.copyWith(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.black,
  );

  // 10
  static get blackS10W300 => _mainFontFamily.copyWith(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w300,
    color: appTheme.black,
  );

  static get primaryS10W500 => _mainFontFamily.copyWith(
    fontSize: 6.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.primary,
  );

  // 14
  static get blackS14W600 => _mainFontFamily.copyWith(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.black,
  );

  // 16
  static get blackS16W400 => _mainFontFamily.copyWith(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.black,
  );

  static get blackS16W600 => _mainFontFamily.copyWith(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.black,
  );

  static get whiteS16W400 => _mainFontFamily.copyWith(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.white,
  );

  static get redS16W400 => _mainFontFamily.copyWith(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.redA700,
  );

  static get primaryS16W500 => _mainFontFamily.copyWith(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.primary,
  );

  // 18
  static get blackS18W400 => _mainFontFamily.copyWith(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w400,
    color: appTheme.black,
  );

  static get blackS18W600 => _mainFontFamily.copyWith(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.black,
  );

  static get primaryS18W600 => _mainFontFamily.copyWith(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.primary,
  );

  static get whiteS18W600 => _mainFontFamily.copyWith(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.white,
  );

  // 20
  static TextStyle get blackS20W500 => _mainFontFamily.copyWith(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w500, // Bold
    color: appTheme.black,
  );

  static TextStyle get primaryS20W600 => _mainFontFamily.copyWith(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w600, // Bold
    color: appTheme.primary,
  );

  static TextStyle get blackS20W600 => _mainFontFamily.copyWith(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w600, // Bold
    color: appTheme.black,
  );

  static get primaryS24W600 => _mainFontFamily.copyWith(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w600,
    color: appTheme.primary,
  );

  static get primaryS28W500 => _mainFontFamily.copyWith(
    fontSize: 28.fSize,
    fontWeight: FontWeight.w500,
    color: appTheme.primary,
  );

}
