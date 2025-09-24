
import 'dart:io';

import '../api_services/api_client.dart';
import '../api_services/domain/app_exceptions.dart';
import '../api_services/either.dart';
import '../api_services/api_urls.dart';
import '../models/requestOtp/post_otp_resp.dart';
import '../models/verifyOtp/post_verify_otp_resp.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient = ApiClient();

  static final AuthRemoteDataSource _singleton = AuthRemoteDataSource._internal();
  factory AuthRemoteDataSource() {
    return _singleton;
  }
  AuthRemoteDataSource._internal();

  Future<Either<AppException, dynamic>> socialSignIN({
    required String firebaseIdToken,
  }) async {
    final either = await apiClient.post(
      ApiUrls.socialAuth,
      body: {'firebaseIdToken': 'Bearer $firebaseIdToken'}, // Replace with actual token
    );
    return either.mapRight((res) => PostVerifyOtpResp.fromJson(res.data));
  }


}
