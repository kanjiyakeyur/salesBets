

import 'domain/api_response.dart';
import 'domain/app_exceptions.dart';
import 'either.dart';

abstract class NetworkService {
  Map<String, Object> get headers;

  void updateHeader(Map<String, dynamic> data);

  Future<Either<AppException, ApiResponse>> get(
    String endpoint, {
    Map<String, dynamic>? params,
  });

  Future<Either<AppException, ApiResponse>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  });

  Future<Either<AppException, ApiResponse>> delete(
    String endpoint, {
    Map<String, dynamic>? params,
  });
}
