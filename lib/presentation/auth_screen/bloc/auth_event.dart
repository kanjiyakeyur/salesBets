part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the Splash widget is first created.
class OnClickSubmitEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class OnClickGoogleSignInEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class OnClickAppleSignInEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class OnClickEmailSignInEvent extends AuthEvent {
  final String email;
  final String password;

  OnClickEmailSignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class OnClickEmailSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  OnClickEmailSignUpEvent({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class OnClickForgotPasswordEvent extends AuthEvent {
  final String email;

  OnClickForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class SwitchToSignInEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SwitchToSignUpEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}