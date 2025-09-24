import 'dart:async';
import 'dart:developer';

import 'package:baseproject/core/app_export.dart';
import 'package:baseproject/data/sockets/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../api_services/api_urls.dart';
import '../api_services/domain/app_exceptions.dart';
import '../api_services/domain/api_response.dart';
import '../api_services/either.dart';

/// A Socket client that manages real-time communications.
///
/// This class is responsible for establishing and maintaining
/// socket connections to the server, handling events, and providing
/// a clean interface for real-time communications.
///
/// This class does not maintain authentication state itself,
/// but rather receives the token from an external source.
class SocketClient extends SocketService {
  // Private constructor for singleton pattern
  SocketClient._({this.autoConnect = false, this.handleUnauthorized}) {
    _initializeSocket();
  }

  // Static instance variable
  static SocketClient? _instance;

  // Factory constructor that returns the singleton instance
  factory SocketClient({bool autoConnect = false, Future<void> Function()? handleUnauthorized}) {
    _instance ??= SocketClient._(autoConnect: autoConnect, handleUnauthorized: handleUnauthorized);
    return _instance!;
  }

  // Method to get the instance (alternative to factory constructor)
  static SocketClient get instance {
    _instance ??= SocketClient._();
    return _instance!;
  }

  // Method to reset the singleton instance (useful for testing or reinitialization)
  static void reset() {
    _instance?.dispose();
    _instance = null;
  }

  final bool autoConnect;
  final Future<void> Function()? handleUnauthorized;

  late io.Socket socket;
  final _eventControllers = <String, StreamController<dynamic>>{};
  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  void _initializeSocket() {
    socket = io.io(
      ApiUrls.baseUrl,
      io.OptionBuilder()
          .enableForceNewConnection()
          .setTransports(['websocket'])
          .setAuth({
        'token': PrefUtils().getToken()
      })
          .disableAutoConnect()
          .build(),
    );

    // _socket.connect();

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    socket.onConnect((_) {
      log('Socket connected');
      _isConnected = true;
    });

    socket.onDisconnect((_) {
      log('Socket disconnected');
      _isConnected = false;
    });

    socket.onConnectError((error) {
      log('Connect error: $error');
      _isConnected = false;
    });

    socket.onError((error) {
      log('Socket error: $error');
      if (error.toString().contains('401')) {
        handleUnauthorized?.call();
      }
    });

    socket.onReconnect((_) {
      log('Socket reconnecting');
    });

    socket.onReconnectError((error) {
      log('Socket reconnect error: $error');
    });

    socket.on('error', (error) {
      log('Socket emit error: $error');
      // Handle emit errors if needed
    });
  }

  io.Socket? getSocket(){
    return _isConnected ? socket : null;
  }

  /// Getter for the socket instance (for backward compatibility)
  io.Socket get socketInstance => socket;

  @override
  Future<Either<AppException, bool>> connect() async {
    try {
      log('Connecting to socket server at ${ApiUrls.baseUrl}');

      if (socket.connected) {
        return const Right(true);
      }

      final completer = Completer<Either<AppException, bool>>();

      socket.onConnect((_) {
        _isConnected = true;
        if (!completer.isCompleted) {
          completer.complete(const Right(true));
        }
      });

      socket.onConnectError((error) {
        log('Socket connect error: $error');
        if (!completer.isCompleted) {
          completer.complete(
            Left(
              AppException(
                message: 'Failed to connect to socket server',
                statusCode: 0,
                identifier: 'SocketConnectError: $error',
              ),
            ),
          );
        }
      });

      log('Socket options when connecting: ${socket.io.options}');

      socket.connect();

      // Add timeout to prevent waiting indefinitely
      Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          completer.complete(
            Left(
              AppException(
                message: 'Socket connection timed out',
                statusCode: 408,
                identifier: 'SocketConnectionTimeout',
              ),
            ),
          );
        }
      });

      return await completer.future;
    } catch (e) {
      return Left(
        AppException(
          message: 'An error occurred while connecting to socket',
          statusCode: 500,
          identifier: 'SocketConnectException: $e',
        ),
      );
    }
  }

  @override
  void disconnect() {
    socket.disconnect();
    socket.dispose();
    _isConnected = false;
  }

  @override
  Either<AppException, bool> emit(String event, dynamic data) {
    try {
      if (!_isConnected) {
        return Left(
          AppException(
            message: 'Socket is not connected',
            statusCode: 0,
            identifier: 'SocketNotConnected',
          ),
        );
      }

      socket.emit(event, data);
      return const Right(true);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to emit event',
          statusCode: 0,
          identifier: 'SocketEmitException: $e',
        ),
      );
    }
  }

  /// Emits an event with data and waits for acknowledgment
  /// Returns Either<AppException, ApiResponse> based on the response
  /// 
  /// This method handles the complete response lifecycle:
  /// - Success responses: Returns Right(ApiResponse) with parsed data
  /// - Error responses: Returns Left(AppException) with error details
  /// - Timeout: Returns Left(AppException) with timeout error
  /// - Connection issues: Returns Left(AppException) with connection error
  /// 
  /// Expected response format:
  /// Success: { "success": true, "data": {...}, "message": "..." }
  /// Failure: { "success": false, "error": "Error message" }
  @override
  Future<Either<AppException, ApiResponse>> emitWithAck(String event, dynamic data) async {
    try {
      if (!_isConnected) {
        return Left(
          AppException(
            message: 'Socket is not connected',
            statusCode: 0,
            identifier: 'SocketNotConnected',
          ),
        );
      }

      final completer = Completer<Either<AppException, ApiResponse>>();

      // Emit with acknowledgment using the standard emitWithAck method
      socket.emitWithAck(event, data, ack: (responseData) {
        try {
          if (responseData is Map<String, dynamic>) {
            // Check if response indicates success or failure
            final isSuccess = responseData['success'] as bool? ?? false;
            
            if (isSuccess) {
              // Success response - create ApiResponse with success data
              final apiResponse = ApiResponse(
                statusCode: 200,
                statusMessage: 'Success',
                message: responseData['message'] as String? ?? 'Operation completed successfully',
                data: responseData['data'] ?? {},
                responseData: responseData,
                isSuccess: true,
              );
              completer.complete(Right(apiResponse));
            } else {
              // Failure response
              final errorMessage = responseData['error'] as String? ?? 'Unknown error occurred';
              final appException = AppException(
                message: errorMessage,
                statusCode: 400, // Bad request for socket errors
                identifier: 'SocketEmitAckError: $event',
              );
              completer.complete(Left(appException));
            }
          } else {
            // Invalid response format
            final appException = AppException(
              message: 'Invalid response format from socket server',
              statusCode: 500,
              identifier: 'SocketEmitAckInvalidResponse: $event',
            );
            completer.complete(Left(appException));
          }
        } catch (e) {
          // Error parsing response
          final appException = AppException(
            message: 'Failed to parse socket response: $e',
            statusCode: 500,
            identifier: 'SocketEmitAckParseError: $event',
          );
          completer.complete(Left(appException));
        }
      });

      // Add timeout to prevent waiting indefinitely
      Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.complete(
            Left(
              AppException(
                message: 'Socket emit acknowledgment timed out',
                statusCode: 408,
                identifier: 'SocketEmitAckTimeout: $event',
              ),
            ),
          );
        }
      });

      return await completer.future;
    } catch (e) {
      return Left(
        AppException(
          message: 'An error occurred while emitting event with acknowledgment',
          statusCode: 500,
          identifier: 'SocketEmitAckException: $e',
        ),
      );
    }
  }

  /// Convenience method for emit with acknowledgment that returns ApiResponse directly
  /// This method is similar to the pattern used in existing code
  /// 
  /// Returns:
  /// - ApiResponse on success
  /// - null on error, timeout, or connection issues
  /// 
  /// Note: This method doesn't provide detailed error information.
  /// Use emitWithAck() if you need error handling with AppException details.
  @override
  Future<ApiResponse?> emitWithAckAsync(String event, dynamic data) async {
    try {
      if (!_isConnected) {
        return null;
      }

      final completer = Completer<ApiResponse?>();

      // Emit with acknowledgment using the standard emitWithAck method
      socket.emitWithAck(event, data, ack: (responseData) {
        try {
          if (responseData is Map<String, dynamic>) {
            // Create ApiResponse from the socket response
            final apiResponse = ApiResponse.fromJson(responseData);
            completer.complete(apiResponse);
          } else {
            completer.complete(null);
          }
        } catch (e) {
          log('Error parsing socket response: $e');
          completer.complete(null);
        }
      });

      // Add timeout to prevent waiting indefinitely
      Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      });

      return await completer.future;
    } catch (e) {
      log('Error in emitWithAckAsync: $e');
      return null;
    }
  }

  @override
  Either<AppException, Stream<dynamic>> on(String event) {
    try {
      // Create controller if it doesn't exist for this event
      _eventControllers[event] ??= StreamController<dynamic>.broadcast();

      // Register the event listener if it's not already registered
      socket.off(event);
      socket.on(event, (data) {
        if (_eventControllers.containsKey(event) &&
            !_eventControllers[event]!.isClosed) {
          _eventControllers[event]!.add(data);
        }
      });

      return Right(_eventControllers[event]!.stream);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to listen to event',
          statusCode: 0,
          identifier: 'SocketListenException: $e',
        ),
      );
    }
  }

  @override
  void off(String event) {
    socket.off(event);
    // Close and remove the controller if it exists
    if (_eventControllers.containsKey(event)) {
      _eventControllers[event]!.close();
      _eventControllers.remove(event);
    }
  }

  @override
  void updateAuth({required String token}) {
    try {
      // _socket.io.options?['auth'] = {'token': token};
      socket = io.io(
        ApiUrls.baseUrl,
        io.OptionBuilder()
            .enableForceNewConnection()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .disableAutoConnect()
            .build(),
      );

      _setupSocketListeners();
    } catch (e) {
      log('Failed to update auth: $e');
    }
  }

  @override
  void dispose() {
    // Close all event controllers
    for (final controller in _eventControllers.values) {
      controller.close();
    }
    _eventControllers.clear();

    // Disconnect socket
    disconnect();
  }
}
