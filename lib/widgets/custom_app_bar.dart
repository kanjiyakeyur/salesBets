// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:baseproject/bloc/user/user_bloc.dart';
import 'package:baseproject/routes/navigation_args.dart';

// Project imports:
import '../../core/app_export.dart';
import 'custom_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.shape,
    this.leadingWidth,
    this.title,
    this.titleColor,
    this.isBack,
    this.isLogoTitle = false,
    this.showUserProfile = false,
    this.OnTapBack,
  }) : super(key: key);

  final double? height;
  final ShapeBorder? shape;
  final double? leadingWidth;
  final String? title;
  final Color? titleColor;
  final bool? isBack;
  final bool isLogoTitle;
  final bool showUserProfile;
  final VoidCallback? OnTapBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.bottomShadow,
      child: AppBar(
        elevation: null,
        shadowColor: Colors.transparent,
        forceMaterialTransparency: true,
        shape: shape,
        toolbarHeight: height ?? 56.h,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leadingWidth: leadingWidth ?? 76.h,
        leading: getLeadingItem(isBack ?? true),
        title: getTitle(title, titleColor),
        titleSpacing: (isBack ?? true) ? 0.h : 20.h,
        centerTitle: false,
        actions: getTrailingItem(),
        systemOverlayStyle: SystemUiOverlayStyle(// Set your desired color here
          statusBarIconBrightness: Brightness.dark, // For light icons (white)
          statusBarColor: appTheme.background
        ),
      ),
    );
  }

  Widget? getLeadingItem(bool isLeading) {
    if (isLeading) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: 16.h,
          top: 4.h,
          end: 8.h,
          bottom: 4.h,
        ),
        child: Row(
          children: [
            CustomIconButton(
              height: 45.h,
              width: 45.h,
              onTap: () {
                if (OnTapBack != null) {
                  OnTapBack?.call();
                } else {
                  NavigatorService.goBack();
                }
              },
              decoration: IconButtonStyleHelper.fillBlack,
              child: CustomImageView(
                // change it
                height: 24.h,
                width: 24.h,
                imagePath: ImageConstant.backArrow,
              ),
            ),
          ],
        ),
      );
    } else {
      return null;
    }
  }

  Widget? getTitle(String? title, Color? titleColor) {
    if (title != null && title.isNotEmpty) {
      return Text(
        title,
        style:
            isLogoTitle
                ? CustomTextStyles.blackS28W600
                : CustomTextStyles.blackS20W600,
      );
    }
    return null;
  }

  List<Widget> getTrailingItem() {
    List<Widget> actions = [];
    if(showUserProfile){
      actions.add(
        CustomIconButton(
          onTap: () async {
            // NavigatorService.pushNamed(AppRoutes.settingScreen);
          },
          height: 40.h,
          width: 40.h,
          child: CustomImageView(
            imagePath: ImageConstant.userIcon,
            height: 25.h,
            width: 25.h,
          ),
        )
      );
    }
    if (actions.isNotEmpty) {
      actions.add(Padding(padding: EdgeInsetsDirectional.only(start: 12.h)));
    }
    return actions;
  }

  @override
  Size get preferredSize => Size(SizeUtils.width, height ?? 56.h);
}
