part of 'splash_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///Splash widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class SplashEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the Splash widget is first created.
class SplashInitialEvent extends SplashEvent {
  BuildContext context;
  SplashInitialEvent({required this.context});
  @override
  List<Object?> get props => [];
}
