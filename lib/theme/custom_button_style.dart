// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {

  static BoxDecoration get fillPrimaryTL12 =>
      BoxDecoration(
        color: appTheme.primary,
        borderRadius: CustomBorderRadiusStyle.border30,
      );

  static BoxDecoration get fillPrimaryGrayTL12 =>
      BoxDecoration(
        color: appTheme.primaryGray,
        borderRadius: CustomBorderRadiusStyle.border30,
      );

  static BoxDecoration get borderPrimaryTL12 =>
      BoxDecoration(
        color: appTheme.white,
        borderRadius: CustomBorderRadiusStyle.border30,
        border: Border.all(
          color: appTheme.primaryGray,
          width: 1.h,
        ),
      );

  static BoxDecoration get fillRedTL12 =>
      BoxDecoration(
        color: appTheme.redA700,
        borderRadius: CustomBorderRadiusStyle.border30,
      );
}
