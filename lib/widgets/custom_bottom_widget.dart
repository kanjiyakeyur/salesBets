// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../core/app_export.dart';
import '../theme/custom_button_style.dart';
import 'custom_elevated_button.dart';

// ignore_for_file: must_be_immutable
class CustomBottomWidget extends StatelessWidget {
  CustomBottomWidget({
    Key? key,
    this.onTapPrimaryButtonClick,
    this.onTapSecondaryButtonClick,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.secondaryButtonTextStyle,
  }) : super(
          key: key,
        );
  String? primaryButtonText;
  String? secondaryButtonText;
  TextStyle? secondaryButtonTextStyle;
  VoidCallback? onTapPrimaryButtonClick, onTapSecondaryButtonClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsetsDirectional.all(16.h),
      decoration: AppDecoration.fillGray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              spacing: 8.h,
              children: [
                if (secondaryButtonText != null)
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () {
                        onTapSecondaryButtonClick?.call();
                      },
                      height: 56.h,
                      text: secondaryButtonText ?? "",
                      // buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                      // buttonTextStyle: (secondaryButtonTextStyle != null)
                      //     ? secondaryButtonTextStyle
                      //     : CustomTextStyles.bodyText,
                    ),
                  ),
                if (primaryButtonText != null)
                  Expanded(
                    child: CustomElevatedButton(
                      height: 56.h,
                      onPressed: () {
                        onTapPrimaryButtonClick?.call();
                      },
                      text: primaryButtonText ?? "",
                      // buttonStyle: CustomButtonStyles.fillPrimaryTL12,
                      // buttonTextStyle: CustomTextStyles.bodyText,
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
