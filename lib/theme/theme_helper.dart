// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();

ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = PrefUtils().getThemeData();

// A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
    'darkCode': DarkCodeColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
    'darkCode': ColorSchemes.darkCodeColorScheme
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      // textTheme: TextThemes.textTheme(colorScheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsetsDirectional.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.primaryGray,
            width: 2.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsetsDirectional.zero,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          width: 1,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      // dividerTheme: DividerThemeData(
      //   thickness: 1,
      //   space: 1,
      //   color: appTheme.gray100,
      // ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
// class TextThemes {
//   static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
//         displayLarge: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 57.fSize,
//           fontWeight: FontWeight.w700, // Bold
//         ),
//         displayMedium: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 45.fSize,
//           fontWeight: FontWeight.w700, // Bold
//         ),
//         displaySmall: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 36.fSize,
//           fontWeight: FontWeight.w700, // Bold
//         ),
//         headlineLarge: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 32.fSize,
//           fontWeight: FontWeight.w700, // Bold
//         ),
//         headlineMedium: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 28.fSize,
//           fontWeight: FontWeight.w700, // Bold
//         ),
//         headlineSmall: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 24.fSize,
//           fontWeight: FontWeight.w500, // Medium
//         ),
//         titleLarge: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 22.fSize,
//           fontWeight: FontWeight.w700, // Medium
//         ),
//         titleMedium: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 16.fSize,
//           fontWeight: FontWeight.w600, // Medium
//         ),
//         titleSmall: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 14.fSize,
//           fontWeight: FontWeight.w500, // Medium
//         ),
//         bodyLarge: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 16.fSize,
//           fontWeight: FontWeight.w400, // Regular
//         ),
//         bodyMedium: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 14.fSize,
//           fontWeight: FontWeight.w400, // Regular
//         ),
//         bodySmall: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 12.fSize,
//           fontWeight: FontWeight.w400, // Regular
//         ),
//         labelLarge: TextStyle(
//           color: appTheme.gray600,
//           fontFamily: 'Inter',
//           fontSize: 14.fSize,
//           fontWeight: FontWeight.w500, // Medium
//         ),
//         labelMedium: TextStyle(
//           color: appTheme.white,
//           fontFamily: 'Inter',
//           fontSize: 12.fSize,
//           fontWeight: FontWeight.w500, // Medium
//         ),
//         labelSmall: TextStyle(
//           fontFamily: 'Inter',
//           color: appTheme.gray600,
//           fontSize: 10.fSize,
//           fontWeight: FontWeight.w500, // Medium
//         ),
//
//       );
// }

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    //primary: Color(0XFF5B82F9), //Blue
    primary: Color(0XFFBA7041),
    //Blue
    primaryContainer: Color(0XFF242424),
    //Black
    errorContainer: Color(0X3F000000),
    onError: Color(0XCC34A853),
    onErrorContainer: Color(0XFF2F2F2F),
    onPrimary: Color(0X66141414),
    onPrimaryContainer: Color(0XCCFDC868),
  );

  static final darkCodeColorScheme = ColorScheme.dark(
    primary: Color(0XFFBA7041),
    primaryContainer: Color(0XFF1A1A1A),
    surface: Color(0XFF121212),
    background: Color(0XFF121212),
    errorContainer: Color(0X3FFFFFFF),
    onError: Color(0XCC34A853),
    onErrorContainer: Color(0XFFD1D1D1),
    onPrimary: Color(0X66FFFFFF),
    onPrimaryContainer: Color(0XCCFDC868),
    onSurface: Color(0XFFFFFFFF),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {

  // New -------
  Color get primary => Color(0XFFBA7041);
  Color get primaryGray => Color(0XFFD7CFBA);
  Color get primaryLight => Color(0XFFFFF0E6);

  Color get background => Color(0XFFFFF9F5);

  Color get white => Color(0XFFFFF9F5);
  Color get black => Color(0XFF2A2D26);
  Color get gray => Color(0XFF2A2C27);
  Color get lightGray => Color(0XFFD3D3D3);

  Color get gradient1 => Color(0XFFF3E0D5);
  Color get gradient2 => Color(0XFFFFF9F5);

  // old ---------------

// Red
  Color get redA200 => Color(0XFFF95B5B);
  Color get brown => Color(0XFF835D3C);



  Color get redA700 => Color(0XFFFF0000);
  Color get homeBg => Color(0XFFFAF9FA).withValues(alpha: 0.98);
  Color get iconBg => theme.colorScheme.primary.withValues(alpha: 0.06);
}

/// Class containing custom colors for a darkCode theme.
class DarkCodeColors extends LightCodeColors {
  // Override light theme colors for dark theme
  @override
  Color get primary => Color(0XFFBA7041);
  @override
  Color get primaryGray => Color(0XFF3A3A3A);
  @override
  Color get primaryLight => Color(0XFF2A1F1A);

  @override
  Color get background => Color(0XFF121212);

  @override
  Color get white => Color(0XFF1E1E1E);
  @override
  Color get black => Color(0XFFFFFFFF);
  @override
  Color get gray => Color(0XFFCCCCCC);
  @override
  Color get lightGray => Color(0XFF3A3A3A);

  @override
  Color get gradient1 => Color(0XFF2A2A2A);
  @override
  Color get gradient2 => Color(0XFF1A1A1A);

  @override
  Color get homeBg => Color(0XFF1A1A1A).withValues(alpha: 0.98);
  @override
  Color get iconBg => theme.colorScheme.primary.withValues(alpha: 0.15);
}
