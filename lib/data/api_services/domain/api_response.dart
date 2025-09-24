// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'app_exceptions.dart';

class ApiResponse {
  ApiResponse({
    required this.statusCode,
    this.statusMessage,
    this.message,
    this.data = const <dynamic, dynamic>{},
    this.responseData = const <dynamic, dynamic>{},
    this.isSuccess,
  });

  factory ApiResponse.empty() => ApiResponse(statusCode: 0, statusMessage: '');

  final int statusCode;
  final String? statusMessage;
  final String? message;
  final bool? isSuccess;
  final dynamic data;
  final dynamic responseData;

  @override
  String toString() {
    return 'statusCode=$statusCode\isSuccess=$isSuccess\nstatusMessage=$statusMessage\n'
        ' data=$data\n message=$message';
  }

  ApiResponse.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'] ?? 0 ,
        statusMessage = json['statusMessage'] ?? '',
        message = json['message'] ?? '',
        data = json['data'] ?? {},
        responseData = json['responseData'] ?? {},
        isSuccess = json['isSuccess'] ?? false;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(covariant ApiResponse other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode &&
        other.statusMessage == statusMessage &&
        other.data == data &&
        other.isSuccess == isSuccess;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      statusCode.hashCode ^ statusMessage.hashCode ^ data.hashCode;
}

extension ResponseExtension on ApiResponse {
  (AppException?, ApiResponse) get toRight => (null, this);
}
