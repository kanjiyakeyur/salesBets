# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Core Flutter Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app in debug mode
- `flutter run --release` - Run the app in release mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter test` - Run all tests
- `flutter analyze` - Static analysis using rules from analysis_options.yaml

### Code Generation
- `flutter packages pub run build_runner build` - Generate Hive type adapters and other generated code
- `flutter packages pub run build_runner build --delete-conflicting-outputs` - Regenerate with conflict resolution

### Platform-specific Commands
- iOS: Open `ios/Runner.xcworkspace` in Xcode for iOS-specific configuration
- Android: Use Android Studio or `./gradlew` commands from the android directory

## Architecture

This Flutter project follows a **Clean Architecture** pattern with **BLoC** state management:

### Core Architecture Layers
- **Presentation Layer** (`lib/presentation/`): UI screens organized by feature (auth_screen, dashboard, splash_screen)
- **BLoC Layer** (`lib/bloc/`): State management using flutter_bloc pattern
- **Data Layer** (`lib/data/`): Data sources and repositories
- **Core** (`lib/core/`): Shared utilities, constants, and app-wide configurations

### Key Architectural Components
- **State Management**: Uses BLoC pattern with flutter_bloc package
- **Navigation**: Custom route generation with platform-specific transitions (CupertinoPageRoute for iOS, PageTransition for Android)
- **Local Storage**: Hive database for local data persistence + SharedPreferences for simple key-value storage
- **Network**: Dio for HTTP requests
- **Authentication**: Firebase Auth with Google Sign-In and Sign in with Apple support
- **Push Notifications**: Firebase Messaging with local notifications

### Project Structure Highlights
- `lib/core/app_export.dart`: Central export file for commonly used imports
- `lib/main.dart`: App initialization with Firebase, Hive, and notification setup
- `lib/routes/`: App routing configuration
- `lib/theme/`: Centralized theming with BLoC-managed theme switching
- `lib/widgets/`: Reusable UI components
- `lib/localization/`: Internationalization support (English/Arabic)

### Firebase Integration
- Project ID: `sels-demo`
- Configured for both Android and iOS platforms
- Firebase services: Auth, Messaging, Core
- Configuration files: `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`

### Platform Configuration
- **iOS Bundle**: `com.baseproject.app` with display name "Base Project"
- **Android Package**: `com.baseproject.app`
- **Minimum SDK**: Android API 23, iOS 13.0
- **Target SDK**: Android 35 (configurable via flutter.targetSdkVersion)

### Dependencies of Note
- **UI**: flutter_svg, lottie, carousel_slider, cached_network_image
- **State Management**: flutter_bloc, equatable
- **Storage**: hive, shared_preferences
- **Network**: dio, connectivity_plus
- **Authentication**: firebase_auth, google_sign_in, sign_in_with_apple
- **Utilities**: permission_handler, device_info_plus, uuid
- **Development**: build_runner (for code generation), flutter_lints

### Code Generation Requirements
This project uses Hive for local storage which requires code generation. After adding new Hive models or making changes to existing ones, run the build_runner command to regenerate type adapters.