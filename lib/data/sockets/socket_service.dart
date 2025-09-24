
import '../api_services/domain/app_exceptions.dart';
import '../api_services/either.dart';
import '../api_services/domain/api_response.dart';

/// Abstract class defining the contract for socket services.
/// 
/// This service provides methods for real-time communication via WebSocket connections.
/// 
/// Key features:
/// - Connection management (connect, disconnect)
/// - Event emission with and without acknowledgment
/// - Event listening and subscription management
/// - Authentication handling
/// 
/// Usage examples:
/// 
/// ```dart
/// // Basic emit without acknowledgment
/// final result = socketService.emit('event_name', data);
/// 
/// // Emit with acknowledgment - returns Either<AppException, ApiResponse>
/// final result = await socketService.emitWithAck('event_name', data);
/// result.fold(
///   (exception) => handleError(exception),
///   (response) => handleSuccess(response),
/// );
/// 
/// // Convenience method for backward compatibility
/// final response = await socketService.emitWithAckAsync('event_name', data);
/// if (response != null) {
///   handleSuccess(response);
/// }
/// ```
abstract class SocketService {
  /// Returns whether the socket is currently connected
  bool get isConnected;

  /// Connects to the socket server
  Future<Either<AppException, bool>> connect();

  /// Disconnects from the socket server
  void disconnect();

  /// Emits an event with data to the socket server
  Either<AppException, bool> emit(String event, dynamic data);

  /// Emits an event with data and waits for acknowledgment
  /// Returns Either<AppException, ApiResponse> based on the response
  Future<Either<AppException, ApiResponse>> emitWithAck(String event, dynamic data);

  /// Convenience method for emit with acknowledgment that returns ApiResponse directly
  /// This method is similar to the pattern used in existing code
  Future<ApiResponse?> emitWithAckAsync(String event, dynamic data);

  /// Listens for events from the socket server
  Either<AppException, Stream<dynamic>> on(String event);

  /// Stops listening to a specific event
  void off(String event);

  /// Updates the authentication headers/data for the socket
  void updateAuth({required String token});

  /// Disposes resources used by the socket service
  void dispose();
}
