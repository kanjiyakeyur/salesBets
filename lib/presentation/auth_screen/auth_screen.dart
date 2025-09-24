// Flutter imports:
import 'dart:io';

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
      create: (context) => AuthBloc(AuthState(
        emailController: TextEditingController(text: "kanjiyakeyur01@gmail.com"),
        passwordController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
        displayNameController: TextEditingController(),
          authMode: AuthMode.emailSignIn
      )),
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
                SizedBox(height: 50.h), // Optional: for spacing
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
      // Logo and App Name
      CustomImageView(
        imagePath: ImageConstant.imageNotFound,
        height: 100.h,
        width: 100.h,
        radius: BorderRadius.circular(12.h),
      ),
      SizedBox(height: 10.h),
      Text("Sales Bets", style: CustomTextStyles.logoText),
      SizedBox(height: 40.h),

      // Auth Mode Toggle
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              // Mode Toggle Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(SwitchToSignInEvent());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: state.authMode == AuthMode.emailSignIn
                              ? appTheme.primary : Colors.transparent,
                          border: Border.all(color: appTheme.primary),
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: state.authMode == AuthMode.emailSignIn
                                ? Colors.white : appTheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(SwitchToSignUpEvent());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: state.authMode == AuthMode.emailSignUp
                              ? appTheme.primary : Colors.transparent,
                          border: Border.all(color: appTheme.primary),
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: state.authMode == AuthMode.emailSignUp
                                ? Colors.white : appTheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Display Name Field (only for sign up)
              if (state.authMode == AuthMode.emailSignUp)
                Column(
                  children: [
                    BlocSelector<AuthBloc, AuthState, TextEditingController?>(
                      selector: (state) => state.displayNameController,
                      builder: (context, controller) {
                        return CustomTextFormField(
                          controller: controller!,
                          hintText: "Full Name",
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          formKey: _formKey,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your full name";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),

              // Email Field
              BlocSelector<AuthBloc, AuthState, TextEditingController>(
                selector: (state) => state.emailController,
                builder: (context, controller) {
                  return CustomTextFormField(
                    controller: controller,
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
                      if (!regex.hasMatch(value)) {
                        return "msg_enter_valid_email".tr;
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 15.h),

              // Password Field
              BlocSelector<AuthBloc, AuthState, TextEditingController?>(
                selector: (state) => state.passwordController,
                builder: (context, controller) {
                  return CustomTextFormField(
                    controller: controller!,
                    hintText: "Password",
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: state.authMode == AuthMode.emailSignUp
                        ? TextInputAction.next : TextInputAction.done,
                    obscureText: true,
                    formKey: _formKey,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (state.authMode == AuthMode.emailSignUp && value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 15.h),

              // Confirm Password Field (only for sign up)
              if (state.authMode == AuthMode.emailSignUp)
                Column(
                  children: [
                    BlocSelector<AuthBloc, AuthState, TextEditingController?>(
                      selector: (state) => state.confirmPasswordController,
                      builder: (context, controller) {
                        return CustomTextFormField(
                          controller: controller!,
                          hintText: "Confirm Password",
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          formKey: _formKey,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != state.passwordController?.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),

              // Forgot Password Link (only for sign in)
              if (state.authMode == AuthMode.emailSignIn)
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _onForgotPassword(context),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: appTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20.h),

              // Sign In/Up Button
              CustomElevatedButton(
                text: state.authMode == AuthMode.emailSignIn ? "Sign In" : "Create Account",
                width: double.maxFinite,
                onPressed: () => _onTapEmailAuth(context),
              ),
              SizedBox(height: 20.h),

              // Divider
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
            ],
          );
        },
      ),
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

  void _onTapEmailAuth(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authBloc = context.read<AuthBloc>();
      final state = authBloc.state;

      if (state.authMode == AuthMode.emailSignIn) {
        authBloc.add(OnClickEmailSignInEvent(
          email: state.emailController.text,
          password: state.passwordController!.text,
        ));
      } else if (state.authMode == AuthMode.emailSignUp) {
        authBloc.add(OnClickEmailSignUpEvent(
          email: state.emailController.text,
          password: state.passwordController!.text,
          displayName: state.displayNameController!.text,
        ));
      }
    }
  }

  void _onForgotPassword(BuildContext context) {
    final email = context.read<AuthBloc>().state.emailController.text;
    if (email.isNotEmpty) {
      context.read<AuthBloc>().add(OnClickForgotPasswordEvent(email: email));
    } else {
      // Show dialog to enter email for password reset
      _showForgotPasswordDialog(context);
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enter your email address to receive a password reset link."),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: emailController,
                hintText: "Email Address",
                textInputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  context.read<AuthBloc>().add(
                    OnClickForgotPasswordEvent(email: emailController.text),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text("Send Reset Link"),
            ),
          ],
        );
      },
    );
  }

  void _googleLogin(BuildContext context) {
    context.read<AuthBloc>().add(OnClickGoogleSignInEvent());
  }

  void _appleLogin(BuildContext context) {
    context.read<AuthBloc>().add(OnClickAppleSignInEvent());
  }



}
