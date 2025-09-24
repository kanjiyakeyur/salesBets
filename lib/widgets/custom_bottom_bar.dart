// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../core/app_export.dart';
import '../core/utils/constant.dart';

enum BottomBarEnum {
  Home,
  Profile,
}

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

// ignore_for_file: must_be_immutable
class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imageNotFound,
      activeIcon: ImageConstant.imageNotFound,
      title: "lbl_home".tr,
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imageNotFound,
      activeIcon: ImageConstant.imageNotFound,
      title: "lbl_profile".tr,
      type: BottomBarEnum.Profile,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.white,
        borderRadius: BorderRadius.circular(
          12.h,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.primaryGray,
            spreadRadius: 1.h,
            blurRadius: 1.h,
            offset: Offset(
              0,
              -3,
            ),
          )
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          if (bottomMenuList[index].isCircle) {
            return BottomNavigationBarItem(
              icon: Container(
                height: 48.h,
                width: 48.h,
                decoration: AppDecoration.fillGray,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CustomImageView(
                      imagePath: bottomMenuList[index].icon,
                      height: 14.h,
                      width: 16.h,
                      color: appTheme.white,
                    )
                  ],
                ),
              ),
              label: '',
            );
          }
          return BottomNavigationBarItem(
            icon: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: 16.h,
                ),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: bottomMenuList[index].icon,
                      height: 20.h,
                      width: 22.h,
                      color: appTheme.primaryGray,
                    ),
                    Text(bottomMenuList[index].title ?? "",
                        style: theme.textTheme.titleSmall)
                  ],
                ),
              ),
            ),
            activeIcon: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: 16.h,
                ),
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: bottomMenuList[index].activeIcon,
                      height: 20.h,
                      width: 20.h,
                      color: theme.colorScheme.primary,
                    ),
                    Text(
                      bottomMenuList[index].title ?? "",
                      style: CustomTextStyles.bodyText,
                    )
                  ],
                ),
              ),
            ),
            label: '',
          );
        }),
        onTap: (index) {
          if (index != selectedIndex) {
            selectedIndex = index;
            widget.onChanged?.call(bottomMenuList[index].type);
            setState(() {});
          }
        },
      ),
    );
  }
}

// ignore_for_file: must_be_immutable
class BottomMenuModel {
  BottomMenuModel(
      {required this.icon,
      required this.activeIcon,
      this.title,
      required this.type,
      this.isCircle = false});

  String icon;

  String activeIcon;

  String? title;

  BottomBarEnum type;

  bool isCircle;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsetsDirectional.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
