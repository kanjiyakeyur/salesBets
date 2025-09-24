import 'dart:developer';

import 'package:baseproject/data/api_services/utils/exception_handler_mixin.dart';
import 'package:dio/dio.dart';

import 'api_urls.dart';
import 'network_interceptor.dart';
import 'domain/api_response.dart';
import 'domain/app_exceptions.dart';
import 'either.dart';
import 'network_service.dart';

typedef ApiClientException = DioException;
typedef ApiClientResponse<T> = Response<T>;
typedef ApiClientRequestOptions = RequestOptions;
// typedef _ResponseData = Map<String, Object?>;

extension ApiClientExceptionX on ApiClientException {
  String? get responseMessage {
    final data = response?.data;

    if (data is! Map) return null;

    return (response?.data as Map?)?['message'] as String?;
  }
}

/// An API client that makes network requests.
///
/// This class is meant to be seen as a
/// representation of the common API contract
/// or API list (such as Swagger or Postman) given by the backend.
///
/// This class does not maintain authentication state,
/// but rather receive the token
/// from external source.
///
/// When a widget or provider wants to make a network request, it should not
/// instantiate this class, but instead call the provider that exposes an object
/// of this type.
class ApiClient extends NetworkService with ExceptionHandlerMixin {
  final Dio _httpClient;
  final Future<void> Function()? handleUnauthorized;

  static final ApiClient _singleton = ApiClient._internal();
  
  factory ApiClient({Future<void> Function()? handleUnauthorized}) {
    return _singleton;
  }
  
  ApiClient._internal({this.handleUnauthorized}) : _httpClient = Dio(_defaultOptions)..interceptors.add(AuthInterceptor());

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: ApiUrls.baseUrl,

  );

  @override
  String toString() {
    return 'ApiClient(baseUrl: ${_httpClient.options.baseUrl}, '
        ' _httpClient.options.headers["Authorization"]:'
        ' ${_httpClient.options.headers['Authorization']})';
  }

  @override
  Map<String, Object> get headers => {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  @override
  Map<String, dynamic>? updateHeader(Map<String, dynamic> data) {
    final header = {...data, ...headers};
    _httpClient.options.headers = header;

    return header;
  }

  @override
  Future<Either<AppException, ApiResponse>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool logDetails = false,
  }) async {
    if (logDetails) {
      log('Endpoint: $endpoint');
      log('Body: $body');
      log('Headers: ${_httpClient.options.headers}');
    }
    final res = await handleException(
      () => _httpClient.post(endpoint, data: body),
      endpoint: endpoint,
      handleUnauthorized: handleUnauthorized,
      // refreshToken: refreshToken,
    );
    return res;
  }

  @override
  Future<Either<AppException, ApiResponse>> get(
    String endpoint, {
    Map<String, dynamic>? params,
    bool logDetails = false,
  }) async {
    if (logDetails) {
      log('Endpoint: $endpoint');
      log('Headers: ${_httpClient.options.headers}');
    }
    final res = await handleException(
      () => _httpClient.get(endpoint, queryParameters: params),
      endpoint: endpoint,
      handleUnauthorized: handleUnauthorized,
      // refreshToken: refreshToken,
    );
    return res;
  }

  @override
  Future<Either<AppException, ApiResponse>> delete(
    String endpoint, {
    Map<String, dynamic>? params,
    bool logDetails = false,
  }) async {
    if (logDetails) {
      log('Endpoint: $endpoint');
      log('Headers: ${_httpClient.options.headers}');
    }
    final res = await handleException(
      () => _httpClient.delete(endpoint, queryParameters: params),
      endpoint: endpoint,
      handleUnauthorized: handleUnauthorized,
      // refreshToken: refreshToken,
    );
    return res;
  }

  @override
  Future<Either<AppException, ApiResponse>> put(
      String endpoint, {
        Map<String, dynamic>? body,
        bool logDetails = false,
      }) async {
    if (logDetails) {
      log('Endpoint: $endpoint');
      log('Body: $body');
      log('Headers: ${_httpClient.options.headers}');
    }
    final res = await handleException(
          () => _httpClient.put(endpoint, data: body),
      endpoint: endpoint,
      handleUnauthorized: handleUnauthorized,
      // refreshToken: refreshToken,
    );
    return res;
  }

  @override
  Future<Either<AppException, ApiResponse>> patch(
    String endpoint, {
    Map<String, dynamic>? params,
    bool logDetails = false,
  }) async {
    if (logDetails) {
      log('Endpoint: $endpoint');
      log('Body: $params');
      log('Headers: ${_httpClient.options.headers}');
    }
    final res = await handleException(
      () => _httpClient.patch(endpoint, data: params),
      endpoint: endpoint,
      handleUnauthorized: handleUnauthorized,
      // refreshToken: refreshToken,
    );
    return res;
  }

  // Multipart PUT request for file upload
  Future<Either<AppException, ApiResponse>> putMultipart(
    String endpoint, {
    required String filePath,
    required String fileField,
    Map<String, String>? fields,
    bool logDetails = false,
        Function(int index)? percentageCallBack ,
  }) async {
    if (logDetails) {
      log('Endpoint: $endpoint');
      log('FilePath: $filePath');
      log('Fields: $fields');
      log('Headers: \\${_httpClient.options.headers}');
    }
    final formData = FormData.fromMap({
      fileField: await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      ...?fields,
    });
    final res = await handleException(
      () => _httpClient.put(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          int percentage = (progress * 100).round();
          if(percentageCallBack != null){
            percentageCallBack(percentage);
          }
        },
      ),
      endpoint: endpoint,
      handleUnauthorized: handleUnauthorized,
    );
    return res;
  }

  // Multipart POST request for file upload
  Future<Either<AppException, ApiResponse>> postMultipart(
    String endpoint, {
    required String filePath,
    required String fileField,
    Map<String, String>? fields,
    bool logDetails = false,
    Function(int index)? percentageCallBack,
  }) async {
    if (logDetails) {
      log('Endpoint: $endpoint');
      log('FilePath: $filePath');
      log('Fields: $fields');
      log('Headers: ${_httpClient.options.headers}');
    }
    final formData = FormData.fromMap({
      fileField: await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      ...?fields,
    });
    final res = handleException(
      () => _httpClient.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          int percentage = (progress * 100).round();
          if(percentageCallBack != null){
            percentageCallBack(percentage);
          }
        },
      ),
      endpoint: endpoint,
      handleUnauthorized: handleUnauthorized,
    );
    return res;
  }

  // //  MultipartRequest POST
  // Future<Response> postMultipartRequest(String endpoint,
  //     {Map<String, String>? fields,
  //     required Uint8List file,
  //     String? imageField}) async {
  //   final FormData formData = FormData.fromMap({
  //     imageField ?? 'image': MultipartFile.fromBytes(file,
  //         filename: 'image_${Random().nextInt(100)}.webp'),
  //   });
  //   Options? options;

  //   if (fields != null) {
  //     fields.forEach((key, value) {
  //       formData.fields.add(MapEntry(key, value));
  //     });
  //   }
  //   final Response<dynamic> response = await dio.post(
  //     endpoint,
  //     data: formData,
  //     options: options,
  //   );

  //   return response;
  // }
}
