import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:baseproject/core/app_export.dart';
import 'package:baseproject/core/utils/utility.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/models/verifyOtp/post_verify_otp_resp.dart';
import '../../../data/repository/auth_repo.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthState initState) : super(initState) {
    on<OnClickSubmitEvent>(_onClickSubmit);
    on<OnClickGoogleSignInEvent>(_onClickGoogleSignIn);
    on<OnClickAppleSignInEvent>(_onClickAppleSignIn);
  }

  _onClickSubmit(OnClickSubmitEvent event, Emitter<AuthState> emit) async {
    // await NavigatorService.pushNamed(
    //   AppRoutes.otpVerification,
    //   arguments: {NavigationArgs.userEmail: state.emailController.text},
    // );
  }

  Future<void> _onClickGoogleSignIn(
    OnClickGoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      ProgressDialogUtils.showProgressDialog();
      final googleSignIn = GoogleSignIn();
      FirebaseAuth auth = FirebaseAuth.instance;

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        ProgressDialogUtils.hideProgressDialog();
        return;
      }

      final googleAuth = await googleUser.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in ⁠ appleCredential.identityToken ⁠, sign in will fail.
      final authResult = await auth.signInWithCredential(googleCredential);

      var idToken = await authResult.user?.getIdToken();

      await _requestForLogin(idToken, emit);
    } on PlatformException catch (err) {
      print('handleSignInWithGoogle :: PlatformException ::$err');
    } catch (e) {
      print(e);
    }
    ProgressDialogUtils.hideProgressDialog();
  }

  _onClickAppleSignIn(
    OnClickAppleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      ProgressDialogUtils.showProgressDialog();
      FirebaseAuth auth = FirebaseAuth.instance;
      // Request credential for the currently signed in Apple account. AuthorizationCredentialAppleID
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an ⁠ OAuthCredential ⁠ from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in ⁠ appleCredential.identityToken ⁠, sign in will fail.
      final authResult = await auth.signInWithCredential(oauthCredential);

      var idToken = await authResult.user?.getIdToken();

      await _requestForLogin(idToken, emit);
    } catch (e) {
      print(e.toString());
    }
    ProgressDialogUtils.hideProgressDialog();
  }

  _requestForLogin(String? idToken, Emitter emit) async {
    if (idToken != null) {
      final repository = AuthRemoteDataSource();
      final res = await repository.socialSignIN(firebaseIdToken: idToken);
      res.fold(
        (failure) {
          showToast(failure.message);
        },
        (response) async {
          await _onSuccessLogin(response);
        },
      );
    }
  }

  _onSuccessLogin(PostVerifyOtpResp response) async {
    if (response.success ?? false) {
      NavigatorService.navigatorKey.currentContext?.read<UserBloc>().add(
        (LoginEvent(
          postVerifyOtpResp: response,
          callback: () async {
            await NavigatorService.callHomeScreen();
          },
        )),
      );
    }
  }
}
