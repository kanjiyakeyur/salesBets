// Flutter imports:
import 'package:baseproject/bloc/user/user_bloc.dart';
import 'package:baseproject/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../routes/app_routes.dart';

import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';

// ignore_for_file: must_be_immutable
class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    return navigatorKey.currentState?.pop();
  }

  static void goBackWithResult({dynamic arguments}) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop(arguments);
    }
  }
  static Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    bool routePredicate = false,
    dynamic arguments,
  }) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => routePredicate,
        arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }

  Future<void> openAppSettingsManually() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data:
            '', // Replace with your app's package name
      );
      await intent.launch();
    } else if (Platform.isIOS) {
      // iOS: Open settings using permission_handler's method
      await openAppSettings();
    } // In case of unsupported platform
  }

  static UserBloc getUserState() {
    UserBloc? userState = navigatorKey.currentContext?.read<UserBloc>();
    if (userState != null) {
      return userState;
    } else {
      return UserBloc(UserState());
    }
  }

  static Future<void> callHomeScreen() async {
    UserState? userState = navigatorKey.currentContext?.read<UserBloc>().state;
    if(userState!= null){
      if (!(userState.isAuthenticated ?? false)){
        print("--- Auth");
        await pushNamedAndRemoveUntil(
          AppRoutes.authScreen,
        );
        return;
      } else {
        print("--- dashboard");
        await pushNamedAndRemoveUntil(
          AppRoutes.dashboardScreen,
        );
        return;
      }
    } else {
      pushNamedAndRemoveUntil(
        AppRoutes.authScreen,
      );
      return;
    }
  }

}
