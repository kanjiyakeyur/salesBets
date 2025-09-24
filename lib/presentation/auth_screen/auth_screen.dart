// Flutter imports:
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:baseproject/data/api_services/api_client.dart';
import 'package:baseproject/data/api_services/api_urls.dart';
import 'package:baseproject/presentation/auth_screen/bloc/auth_bloc.dart';
import 'package:baseproject/widgets/custom_elevated_button.dart';
import 'package:baseproject/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/app_export.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create:
          (context) =>
              AuthBloc(AuthState(emailController: TextEditingController(
                text: "kanjiyakeyur01@gmail.com",
              ))),
      child: AuthScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          // width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Optional: for spacing
                ...middleBody(context),
                socialAuthButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> middleBody(BuildContext context) {
    return <Widget>[
      // Spacer(),
      CustomImageView(
        imagePath: ImageConstant.imageNotFound,
        height: 100.h,
        width: 100.h,
        radius: BorderRadius.circular(12.h),
      ),
      SizedBox(height: 10.h),
      Text("lbl_your_app".tr, style: CustomTextStyles.logoText),
      SizedBox(height: 150.h),
      // SizedBox(
      //   width: double.maxFinite,
      //   child: Text(
      //     "lbl_enter_your_email".tr,
      //     textAlign: TextAlign.start,
      //     style: CustomTextStyles.blackS18W400,
      //   ),
      // ),

      BlocSelector<AuthBloc, AuthState, TextEditingController>(
        selector: (AuthState state) {
          return state.emailController;
        },
        builder: (context, state) {
          return CustomTextFormField(
            controller: state,
            hintText: "lbl_your_email".tr,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            formKey: _formKey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "msg_enter_your_email".tr;
              }
              String pattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value)){
                return "msg_enter_valid_email".tr;
              }
              return null;
            },
          );
        },
      ),
      SizedBox(height: 15.h),
      CustomElevatedButton(
        text: "lbl_get_started".tr,
        width: double.maxFinite,
        onPressed: () {
          _onTapNext(context);
        },
      ),
      SizedBox(height: 20.h),
      Row(
        children: [
          Expanded(
            child: Divider(color: appTheme.black, height: 1.h, thickness: 1.h),
          ),
          SizedBox(width: 25.h),
          Text("lbl_or".tr, style: CustomTextStyles.blackS16W400),
          SizedBox(width: 25.h),
          Expanded(
            child: Divider(color: appTheme.black, height: 1.h, thickness: 1.h),
          ),
        ],
      ),
      SizedBox(height: 20.h),
    ];
  }

  Widget socialAuthButtons(BuildContext context) {
    return Row(
      spacing: 20.h,
      children: [
        socialAuthButton(
          text: "lbl_google".tr,
          imagePath: ImageConstant.googleLogo,
          onPressed: () {
            _googleLogin(context);
          },
        ),
        if(Platform.isIOS)
        socialAuthButton(
          text: "lbl_apple".tr,
          imagePath: ImageConstant.appleLogo,
          onPressed: () {
            _appleLogin(context);
          },
        ),
      ],
    );
  }

  Widget socialAuthButton({
    required String text,
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
          decoration: AppDecoration.borderPrimaryB10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: imagePath,
                height: 24.h,
                width: 24.h,
              ),
              SizedBox(width: 10.h),
              Text(
                text,
                style: CustomTextStyles.blackS16W400,
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _onTapNext(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(OnClickSubmitEvent());
    }
  }

  void _googleLogin(BuildContext context) {
    context.read<AuthBloc>().add(OnClickGoogleSignInEvent());
  }

  void _appleLogin(BuildContext context) {
    context.read<AuthBloc>().add(OnClickAppleSignInEvent());
  }



}
