import 'package:baseproject/widgets/custom_app_bar.dart';
import 'package:baseproject/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/app_export.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../theme/bloc/theme_bloc.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/utility.dart';

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
        title: "Settings",
        isBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              _buildUserProfileSection(),
              SizedBox(height: 24.h),

              // Account Settings Section
              _buildAccountSettingsSection(),
              SizedBox(height: 24.h),

              // Theme Settings Section
              _buildThemeSettingsSection(),
              SizedBox(height: 24.h),

              // Logout Button
              _buildLogoutButton(context),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        final user = AuthService.currentUser;

        return Container(
          padding: EdgeInsets.all(16.h),
          decoration: AppDecoration.borderPrimaryWithPrimaryLightB10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User Profile",
                style: CustomTextStyles.blackS18W600,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Container(
                    height: 60.h,
                    width: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appTheme.primaryLight,
                      border: Border.all(
                        color: appTheme.primary,
                        width: 2.h,
                      ),
                    ),
                    child: ClipOval(
                      child: user?.photoURL != null
                          ? CustomImageView(
                              imagePath: user!.photoURL!,
                              height: 60.h,
                              width: 60.h,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              size: 30.h,
                              color: appTheme.primary,
                            ),
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? "User",
                          style: CustomTextStyles.blackS16W600,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user?.email ?? "No email",
                          style: CustomTextStyles.blackS14W600,
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildAccountSettingsSection() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.borderPrimaryWithPrimaryLightB10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Settings",
            style: CustomTextStyles.blackS18W600,
          ),
          SizedBox(height: 16.h),
          _buildInfoRow("User ID", AuthService.currentUser?.uid ?? "N/A"),
          _buildInfoRow("Account Created",
            AuthService.currentUser?.metadata.creationTime?.toString().split(' ').first ?? "N/A"),
          _buildInfoRow("Last Sign In",
            AuthService.currentUser?.metadata.lastSignInTime?.toString().split(' ').first ?? "N/A"),
          _buildInfoRow("Email Verified",
            AuthService.currentUser?.emailVerified == true ? "Yes" : "No"),
        ],
      ),
    );
  }



  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
      decoration: AppDecoration.borderPrimaryB10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.h,
            child: Text(
              "$label:",
              style: CustomTextStyles.primaryS16W500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: CustomTextStyles.blackS16W400,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettingsSection() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          padding: EdgeInsets.all(16.h),
          decoration: AppDecoration.borderPrimaryWithPrimaryLightB10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Theme Settings",
                style: CustomTextStyles.blackS18W600,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.h),
                decoration: AppDecoration.borderPrimaryB10,
                child: Row(
                  children: [
                    Icon(
                      themeState.themeType == 'lightCode'
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: appTheme.primary,
                      size: 24.h,
                    ),
                    SizedBox(width: 12.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "App Theme",
                            style: CustomTextStyles.blackS16W600,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            themeState.themeType == 'lightCode'
                                ? "Light Theme"
                                : "Dark Theme",
                            style: CustomTextStyles.blackS14W600,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: themeState.themeType == 'darkCode',
                      onChanged: (bool value) {
                        final newTheme = value ? 'darkCode' : 'lightCode';
                        context.read<ThemeBloc>().add(
                          ThemeChangeEvent(themeType: newTheme),
                        );
                      },
                      activeColor: appTheme.primary,
                      activeTrackColor: appTheme.primaryLight,
                      inactiveThumbColor: appTheme.lightGray,
                      inactiveTrackColor: appTheme.primaryGray,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Logout",
      width: double.maxFinite,
      height: 50.h,
      decoration: BoxDecoration(
        color: appTheme.redA200,
        borderRadius: CustomBorderRadiusStyle.border10,
      ),
      onPressed: () => _showLogoutConfirmation(context),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: CustomBorderRadiusStyle.border10,
          ),
          title: Text("Logout", style: CustomTextStyles.blackS20W600),
          content: Text(
            "Are you sure you want to logout from Sales Bets?",
            style: CustomTextStyles.blackS16W400,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    text: "Cancel",
                    height: 45.h,
                    decoration: AppDecoration.borderPrimaryWithPrimaryLightB10,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: CustomElevatedButton(
                    text: "Logout",
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: appTheme.redA200,
                      borderRadius: CustomBorderRadiusStyle.border10,
                    ),
                    onPressed: () async {
                      await _performLogout(context);
                      Navigator.of(context).pop(); // Close dialog
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {

    try {
      // Update user bloc
      context.read<UserBloc>().add(LogoutEvent(
        callback: () {
          ProgressDialogUtils.hideProgressDialog();
          // Navigation will be handled by the UserBloc
        },
      ));

      // Show success message
      showToast("Logged out successfully");
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      showToast("Failed to logout: ${e.toString()}");
    }
  }
}
