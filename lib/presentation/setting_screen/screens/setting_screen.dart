import 'package:baseproject/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../core/app_export.dart';
import '../../../bloc/user/user_bloc.dart';
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
                  CircleAvatar(
                    radius: 30.h,
                    backgroundColor: appTheme.primaryGray,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Icon(
                            Icons.person,
                            size: 30.h,
                            color: appTheme.primary,
                          )
                        : null,
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
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                          decoration: AppDecoration.fillPrimaryB10,
                          child: Text(
                            userState.isAuthenticated == true ? "Verified" : "Not Verified",
                            style: CustomTextStyles.whiteS16W400.copyWith(fontSize: 12.fSize),
                          ),
                        ),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.h,
            child: Text(
              "$label:",
              style: CustomTextStyles.blackS14W600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: CustomTextStyles.blackS16W400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.redA200,
          shape: RoundedRectangleBorder(
            borderRadius: CustomBorderRadiusStyle.border10,
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        onPressed: () => _showLogoutConfirmation(context),
        child: Text(
          "Logout",
          style: CustomTextStyles.whiteS16W400,
        ),
      ),
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
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: CustomTextStyles.primaryS16W500),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.redA200,
                shape: RoundedRectangleBorder(
                  borderRadius: CustomBorderRadiusStyle.border10,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await _performLogout(context);
              },
              child: Text("Logout", style: CustomTextStyles.whiteS16W400),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    if (!context.mounted) return;

    try {
      // Show loading
      ProgressDialogUtils.showProgressDialog();

      // Sign out from Firebase
      await AuthService.signOut();

      // Check if context is still mounted before using it
      if (!context.mounted) {
        ProgressDialogUtils.hideProgressDialog();
        return;
      }

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
