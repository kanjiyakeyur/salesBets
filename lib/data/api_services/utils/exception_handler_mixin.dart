import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import '../domain/api_response.dart';
import '../domain/app_exceptions.dart';
import '../either.dart';
import '../network_service.dart';

mixin ExceptionHandlerMixin on NetworkService {
  Future<Either<AppException, ApiResponse>> handleException<T extends Object>(
    Future<Response<dynamic>> Function() handler, {
    String endpoint = '',
    Future<String?> Function()? refreshToken,
    Future<void> Function()? handleUnauthorized,
  }) async {
    try {
      final res = await handler();
      final data = res.data;
      final message = data is Map && data['message'] != null && data['message'] is String?
          ? data['message'] as String
          : null;
      final isSuccess = data is Map && data['success'] is bool
          ? data['success'] as bool
          : true;


      // LocalDb.instance.setTokenIntents(0);
      return Right(
        ApiResponse(
          statusCode: res.statusCode ?? 200,
          data: data, // data is Map ? data['data'] : data, // data is Map ? data['data'] : data,
          statusMessage: message ?? res.statusMessage,
          responseData: data is Map ? data['data'] : data,
          isSuccess: isSuccess,
          message: message,
        ),
      );
    } catch (e) {
      var message = '';
      var identifier = '';
      var statusCode = 0;

      log('Runtime type: ${e.runtimeType}');

      switch (e) {
        case SocketException():
          message = 'Unable to connect to the server.';
          statusCode = 0;
          identifier = 'Socket Exception ${e.message}\n at  $endpoint';

        case DioException():
          log('DioException: ${e.message}');
          statusCode = e.response?.statusCode ?? 1;

          if (statusCode == 401) {
            // final token = await refreshToken?.call();
            // if (token != null) {
            //   return handleException(handler, endpoint: endpoint);
            // }
            await handleUnauthorized?.call();
          }
          // message = _getServerErroMessage(e.response?.data);

          final data = e.response?.data;

          final messages = data is Map && data['error'] is String
              ? data['error']
              : 'Unknown error';

          log('data :{$data}');

          final errorMessage = data is Map && data['message'] is String
              ? data['message'] as String
              : null;

          message = messages;

          identifier = 'DioException ${e.message} \nat  $endpoint';

          log('error data :{$data}');

        default:
          message = 'Unknown error occurred';
          statusCode = 2;
          identifier = 'Unknown error $e\n at $endpoint';
      }

      log('Exception: $statusCode, $message, $identifier');

      return Left(
        AppException(
          message: message,
          statusCode: statusCode,
          identifier: identifier,
        ),
      );
    }
  }
}
