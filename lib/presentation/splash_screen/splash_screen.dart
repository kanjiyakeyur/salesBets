// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/app_export.dart';
import 'bloc/splash_bloc.dart';
import 'models/splash_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(SplashState(
        splashModelObj: SplashModel(),
      ))
        ..add(SplashInitialEvent(context: context)),
      child: SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
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
      },
    );
  }
}
