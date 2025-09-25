part of 'dashboard_bloc.dart';

abstract class DashBoardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitEvent extends DashBoardEvent {
  @override
  List<Object?> get props => [];
}

class LoadEventsEvent extends DashBoardEvent {
  final Function? callback;

  LoadEventsEvent({this.callback});

  @override
  List<Object?> get props => [callback];
}

class CreateEventEvent extends DashBoardEvent {
  final Event event;
  final Function? callback;

  CreateEventEvent({required this.event, this.callback});

  @override
  List<Object?> get props => [event, callback];
}

class UpdateEventEvent extends DashBoardEvent {
  final Event event;
  final Function? callback;

  UpdateEventEvent({required this.event, this.callback});

  @override
  List<Object?> get props => [event, callback];
}

class DeleteEventEvent extends DashBoardEvent {
  final String eventId;
  final Function? callback;

  DeleteEventEvent({required this.eventId, this.callback});

  @override
  List<Object?> get props => [eventId, callback];
}

class UpdateEventStatusEvent extends DashBoardEvent {
  final String eventId;
  final BetStatus status;
  final Function? callback;

  UpdateEventStatusEvent({
    required this.eventId,
    required this.status,
    this.callback,
  });

  @override
  List<Object?> get props => [eventId, status, callback];
}

class AddBetToEventEvent extends DashBoardEvent {
  final String eventId;
  final Bet bet;
  final Function? callback;

  AddBetToEventEvent({
    required this.eventId,
    required this.bet,
    this.callback,
  });

  @override
  List<Object?> get props => [eventId, bet, callback];
}
