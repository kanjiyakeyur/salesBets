// Flutter imports:
import 'package:baseproject/presentation/setting_screen/screens/setting_screen.dart';
import 'package:flutter/material.dart';

import '../presentation/auth_screen/auth_screen.dart';
import '../presentation/dashboard/screens/dash_board_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppRoutes {
  static const String dashboardScreen = '/dashboard_screen';
  static const String splashScreen = '/';
  static const String authScreen = '/auth_screen';
  static const String settingScreen = '/setting_screen';

  static Map<String, WidgetBuilder> get routes => {
    splashScreen: SplashScreen.builder,
    authScreen: AuthScreen.builder,
    dashboardScreen: DashboardScreen.builder,
    settingScreen: SettingScreen.builder,

  };
}
