part of 'dashboard_bloc.dart';

class DashBoardState extends Equatable {
  final List<Event> events;
  final bool isLoading;
  final String? errorMessage;

  const DashBoardState({
    this.events = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [events, isLoading, errorMessage];

  DashBoardState copyWith({
    List<Event>? events,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DashBoardState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
