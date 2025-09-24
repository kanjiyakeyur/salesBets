part of 'auth_bloc.dart';

class AuthState extends Equatable {
  AuthState({required this.emailController});

  final TextEditingController emailController;

  AuthState copyWith(TextEditingController? emailController) {
    return AuthState(emailController:
      emailController ?? this.emailController,
    );
  }

  @override
  List<Object?> get props => [];
}
