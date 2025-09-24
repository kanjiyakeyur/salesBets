import 'package:baseproject/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/app_export.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key})
      : super(
    key: key,
  );

  static Widget builder(BuildContext context) {
    return SettingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.background,
      appBar: CustomAppBar(
        isBack: true,
      ),
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
