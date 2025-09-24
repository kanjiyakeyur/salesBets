import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:baseproject/core/app_export.dart';
import 'package:baseproject/core/utils/utility.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/models/sales_bet_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthState initState) : super(initState) {
    on<OnClickSubmitEvent>(_onClickSubmit);
    on<OnClickGoogleSignInEvent>(_onClickGoogleSignIn);
    on<OnClickAppleSignInEvent>(_onClickAppleSignIn);
    on<OnClickEmailSignInEvent>(_onClickEmailSignIn);
    on<OnClickEmailSignUpEvent>(_onClickEmailSignUp);
    on<OnClickForgotPasswordEvent>(_onClickForgotPassword);
    on<SwitchToSignInEvent>(_onSwitchToSignIn);
    on<SwitchToSignUpEvent>(_onSwitchToSignUp);
  }

  _onClickSubmit(OnClickSubmitEvent event, Emitter<AuthState> emit) async {
    // Toggle between sign in and sign up modes, defaulting to sign in
    if (state.authMode == AuthMode.initial) {
      emit(state.copyWith(authMode: AuthMode.emailSignIn));
    }
  }

  _onSwitchToSignIn(SwitchToSignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authMode: AuthMode.emailSignIn, clearError: true));
  }

  _onSwitchToSignUp(SwitchToSignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authMode: AuthMode.emailSignUp, clearError: true));
  }

  Future<void> _onClickEmailSignIn(
    OnClickEmailSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      ProgressDialogUtils.showProgressDialog();

      final user = await AuthService.signInWithEmailPassword(
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        await _handleSuccessfulAuth(user, emit);
      }
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      showToast(e.toString());
      print('Email sign-in error: $e');
    }
  }

  Future<void> _onClickEmailSignUp(
    OnClickEmailSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      ProgressDialogUtils.showProgressDialog();

      final user = await AuthService.signUpWithEmailPassword(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );

      if (user != null) {
        await _handleSuccessfulAuth(user, emit);
      }
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      showToast(e.toString());
      print('Email sign-up error: $e');
    }
  }

  Future<void> _onClickForgotPassword(
    OnClickForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      ProgressDialogUtils.showProgressDialog();

      await AuthService.sendPasswordResetEmail(event.email);

      ProgressDialogUtils.hideProgressDialog();
      showToast('Password reset email sent. Please check your inbox.');
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      showToast(e.toString());
      print('Password reset error: $e');
    }
  }

  Future<void> _onClickGoogleSignIn(
    OnClickGoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      ProgressDialogUtils.showProgressDialog();

      final user = await AuthService.signInWithGoogle();

      if (user == null) {
        ProgressDialogUtils.hideProgressDialog();
        showToast('Google sign-in was cancelled');
        return;
      }

      await _handleSuccessfulAuth(user, emit);
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      showToast(e.toString());
      print('Google sign-in error: $e');
    }
  }

  Future<void> _onClickAppleSignIn(
    OnClickAppleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      ProgressDialogUtils.showProgressDialog();

      final user = await AuthService.signInWithApple();

      if (user != null) {
        await _handleSuccessfulAuth(user, emit);
      }
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      showToast(e.toString());
      print('Apple sign-in error: $e');
    }
  }

  // Handle successful authentication
  Future<void> _handleSuccessfulAuth(User firebaseUser, Emitter<AuthState> emit) async {
    try {
      // Create or update user in Firestore
      final salesBetUser = await UserService.createOrUpdateUser(firebaseUser);

      // Update the user bloc with the authenticated user
      NavigatorService.navigatorKey.currentContext?.read<UserBloc>().add(
        SalesBetLoginEvent(
          user: salesBetUser,
          callback: () async {
            await NavigatorService.callHomeScreen();
          },
        ),
      );

      ProgressDialogUtils.hideProgressDialog();
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      showToast('Failed to complete authentication: $e');
      print('Auth completion error: $e');
    }
  }
}