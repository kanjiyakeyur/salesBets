// Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:baseproject/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';

// Project imports:
import 'core/app_export.dart';
import 'core/utils/hive_database_handler.dart';
import 'core/utils/local_notification.dart';
import 'data/notification_service/firebase_notification_service.dart';
import 'firebase_options.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    LocalNotification.initialize(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    HiveDatabaseHandler().init(),
  ]).then((value) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    runApp(MyApp());
  });
}


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    _notificationService.initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>(
              create:
                  (context) => ThemeBloc(
                    ThemeState(themeType: PrefUtils().getThemeData()),
                  ),
            ),
            BlocProvider<UserBloc>(create: (context) => UserBloc(UserState())),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.white, // Set to primary color
                  statusBarIconBrightness:
                      Brightness.dark, // Light icons (change to dark if needed)
                ),
                child: MaterialApp(
                  theme: theme,
                  title: 'Laxxy',
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: TextScaler.linear(1.0)),
                      child: child!,
                    );
                  },
                  navigatorKey: NavigatorService.navigatorKey,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: [
                    AppLocalizationDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: Locale('en', ''),
                  supportedLocales: [Locale('en', ''), Locale('ar', '')],
                  initialRoute: AppRoutes.splashScreen,
                  navigatorObservers: [routeObserver],
                  // Removed routes: AppRoutes.routes, to force onGenerateRoute usage
                  onGenerateRoute: (settings) {
                    final builder = AppRoutes.routes[settings.name];
                    if (builder != null) {
                      if (Platform.isIOS) {
                        // Use CupertinoPageRoute for iOS to enable swipe-back
                        return CupertinoPageRoute(
                          builder: builder,
                          settings: settings,
                        );
                      } else {
                        // Use PageTransition for Android/others
                        return PageTransition(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOutBack,
                          type: PageTransitionType.fade,
                          child: Builder(
                            builder: (context) => builder(context),
                          ),
                          settings: settings,
                        );
                      }
                    }
                    // Fallback for unknown routes
                    return MaterialPageRoute(
                      builder: (_) => Scaffold(
                        body: Center(child: Text('No route defined for \\${settings.name}')),
                      ),
                      settings: settings,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
