// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../core/app_export.dart';

class AppDecoration {
  // Fill decorations

  static BoxDecoration get screenBackground =>
      BoxDecoration(
          color: appTheme.background
      );

  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.primaryGray,
        borderRadius: CustomBorderRadiusStyle.border30,
      );

  static BoxDecoration get primaryGrayGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        appTheme.gradient2,
        appTheme.gradient1,
      ],
    ),
    borderRadius: CustomBorderRadiusStyle.border10,
  );

  static BoxDecoration get primaryGrayGradientRevert => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        appTheme.gradient1,
        appTheme.gradient2.withValues(alpha: 0),
      ],
    ),
  );


  static BoxDecoration get fillPrimary => BoxDecoration(
    color: appTheme.primary,
  );

  static BoxDecoration get fillPrimaryB10 => BoxDecoration(
        color: appTheme.primary,
        borderRadius: CustomBorderRadiusStyle.border10,
      );

  static BoxDecoration get fillPrimaryGrayB10 => BoxDecoration(
    color: appTheme.primaryGray,
    borderRadius: CustomBorderRadiusStyle.border10,
  );

  static BoxDecoration get fillPrimaryB50 => BoxDecoration(
    color: appTheme.primary,
    borderRadius: CustomBorderRadiusStyle.border50,
  );

  static BoxDecoration get borderPrimaryB10 => BoxDecoration(
        borderRadius: CustomBorderRadiusStyle.border10,
        border: Border.all(
          color: appTheme.primaryGray,
          width: 1.h,
        ),
      );

  static BoxDecoration get borderPrimaryB50 => BoxDecoration(
    borderRadius: CustomBorderRadiusStyle.border50,
    border: Border.all(
      color: appTheme.primaryGray,
      width: 1.h,
    ),
  );

  static BoxDecoration get borderWhiteB50 => BoxDecoration(
    borderRadius: CustomBorderRadiusStyle.border50,
    border: Border.all(
      color: appTheme.white,
      width: 1.h,
    ),
  );

  static BoxDecoration get borderPrimaryWithPrimaryLightB50 => BoxDecoration(
    borderRadius: CustomBorderRadiusStyle.border50,
    border: Border.all(
      color: appTheme.primary,
      width: 1.h,
    ),
    color: appTheme.primaryLight,
  );

  static BoxDecoration get borderPrimaryWithPrimaryLightB10 => BoxDecoration(
    borderRadius: CustomBorderRadiusStyle.border10,
    border: Border.all(
      color: appTheme.primary,
      width: 1.h,
    ),
    color: appTheme.primaryLight,
  );

  static BoxDecoration get bottomGradient => BoxDecoration(
    // gradient bottom to top
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        appTheme.background.withOpacity(1),
        appTheme.background.withOpacity(1),
        appTheme.background.withOpacity(1),
        appTheme.background.withOpacity(0.5),
        appTheme.background.withOpacity(0),
      ],
    ),
  );


  static BoxDecoration get userChatBubble => BoxDecoration(
    borderRadius: CustomBorderRadiusStyle.userChatBubble,
    color: appTheme.primary,
  );

  static BoxDecoration get userFileChatBubble => BoxDecoration(
    borderRadius: CustomBorderRadiusStyle.userChatBubble,
    color: appTheme.primaryLight,
    border: Border.all(
      color: appTheme.primary,
      width: 1.h,
    ),
  );

  static BoxDecoration get primaryLightWithBorder => BoxDecoration(
    borderRadius: CustomBorderRadiusStyle.border10,
    // color: appTheme.primaryLight,
    border: Border.all(
      color: appTheme.primary,
      width: 1.h,
    ),
  );

  static BoxDecoration get topShadow =>
      BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: appTheme.background,
              blurRadius: 18,
              offset: Offset(0, -14),
            ),
          ]
      );

  static BoxDecoration get bottomShadow =>
      BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: appTheme.background,
              blurRadius: 4,
              offset: Offset(0, 8),
            ),
          ]
      );
}

class CustomBorderRadiusStyle {
  // Circle borders
  static BorderRadius get border30 => BorderRadius.circular(30.h);

  static BorderRadius get border10 => BorderRadius.circular(10.h);

  static BorderRadius get border50 => BorderRadius.circular(50.h);

  static BorderRadius get borderT10 => BorderRadius.only(
    topLeft: Radius.circular(10.h),
    topRight: Radius.circular(10.h),
  );

  static BorderRadius get userChatBubble => BorderRadius.only(
    topLeft: Radius.circular(10.h),
    topRight: Radius.circular(10.h),
    bottomLeft: Radius.circular(10.h),
  );

  static BorderRadius get aiChatBubble => BorderRadius.only(
    topLeft: Radius.circular(10.h),
    topRight: Radius.circular(10.h),
    bottomRight: Radius.circular(10.h),
  );

}
