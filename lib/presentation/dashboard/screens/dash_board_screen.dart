// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/app_export.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return DashboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.background,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imageNotFound,
                height: 200.h,
                width: 202.h,
                radius: BorderRadius.circular(
                  12.h,
                ),
              ),
              Text("lbl_your_app".tr, style: CustomTextStyles.logoText),
              SizedBox(height: 24.h)
            ],
          ),
        ),
      ),
    );
  }
}
