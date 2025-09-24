

import 'package:flutter/material.dart';
import 'package:baseproject/core/app_export.dart';

void openCommonDataDialog(String title, String description, BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => SizedBox(
      width: 90.pr,
      child: _simpleData(title, description, context),
    ),
  );
}

void openCommonDataBottomSheet(String title, String description, BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder:
        (context) => _simpleData(title, description, context, expanded: true),
    // AlertDialog(title: Text(title), content: Text(description)),
  );
}

_simpleData(
    String title,
    String description,
    BuildContext context, {
      bool expanded = false,
    }) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 25.h),
        decoration: AppDecoration.primaryGrayGradient,
        width: expanded ? double.maxFinite : null,
        // width: 90.pr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10.h,
          children: [
            CustomImageView(
              width: 80.h,
              height: 80.h,
              imagePath: ImageConstant.backArrow,
            ),
            Text(title, style: CustomTextStyles.blackS24W600),
            SizedBox(
              width: 70.pr,
              child: Text(
                description,
                style: CustomTextStyles.blackS16W400,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


