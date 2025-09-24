
import '../either.dart';
import 'api_response.dart';

class AppException implements Exception {
  AppException({
    required this.message,
    required this.statusCode,
    required this.identifier,
  });

  factory AppException.unknown() {
    return AppException(
      message: 'Unknown error',
      statusCode: 0,
      identifier: 'unknown',
    );
  }

  final String message;
  final int statusCode;
  final String identifier;

  @override
  String toString() {
    return 'statusCode=$statusCode\nmessage=$message\nidentifier=$identifier';
  }
}

//  extension

extension HttpExceptionExtension on AppException {
  Left<AppException, ApiResponse> get toLeft =>
      Left<AppException, ApiResponse>(this);
}
