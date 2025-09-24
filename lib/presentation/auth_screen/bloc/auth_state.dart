part of 'auth_bloc.dart';

enum AuthMode { initial, emailSignIn, emailSignUp, forgotPassword }

class AuthState extends Equatable {
  AuthState({
    required this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    this.displayNameController,
    this.authMode = AuthMode.initial,
    this.isLoading = false,
    this.errorMessage,
  });

  final TextEditingController emailController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final TextEditingController? displayNameController;
  final AuthMode authMode;
  final bool isLoading;
  final String? errorMessage;

  AuthState copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    TextEditingController? displayNameController,
    AuthMode? authMode,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController: confirmPasswordController ?? this.confirmPasswordController,
      displayNameController: displayNameController ?? this.displayNameController,
      authMode: authMode ?? this.authMode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        emailController,
        passwordController,
        confirmPasswordController,
        displayNameController,
        authMode,
        isLoading,
        errorMessage,
      ];
}
