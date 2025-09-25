// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/app_export.dart';
import '../../../data/models/event/event.dart';
import '../../../data/services/event_service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc(DashBoardState initialState) : super(initialState) {
    on<InitEvent>(_onInit);
    on<LoadEventsEvent>(_onLoadEvents);
    on<CreateEventEvent>(_onCreateEvent);
    on<UpdateEventEvent>(_onUpdateEvent);
    on<DeleteEventEvent>(_onDeleteEvent);
    on<UpdateEventStatusEvent>(_onUpdateEventStatus);
    on<AddBetToEventEvent>(_onAddBetToEvent);
    on<RemoveBetFromEventEvent>(_onRemoveBetFromEvent);
  }

  _onInit(
    InitEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    // Logic come here for init
    add(LoadEventsEvent());
  }

  _onLoadEvents(
    LoadEventsEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final events = await EventService.getEvents();
      emit(state.copyWith(
        isLoading: false,
        events: events,
        errorMessage: null,
      ));
      if (event.callback != null) {
        await event.callback!();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  _onCreateEvent(
    CreateEventEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await EventService.createEvent(event.event);
      add(LoadEventsEvent());
      if (event.callback != null) {
        await event.callback!();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  _onUpdateEvent(
    UpdateEventEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await EventService.updateEvent(event.event);
      add(LoadEventsEvent());
      if (event.callback != null) {
        await event.callback!();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  _onDeleteEvent(
    DeleteEventEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await EventService.deleteEvent(event.eventId);
      add(LoadEventsEvent());
      if (event.callback != null) {
        await event.callback!();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  _onUpdateEventStatus(
    UpdateEventStatusEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await EventService.updateEventStatus(event.eventId, event.status);
      add(LoadEventsEvent());
      if (event.callback != null) {
        await event.callback!();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  _onAddBetToEvent(
    AddBetToEventEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await EventService.addBetToEvent(event.eventId, event.bet);
      add(LoadEventsEvent());
      if (event.callback != null) {
        await event.callback!();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  _onRemoveBetFromEvent(
    RemoveBetFromEventEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await EventService.removeBetFromEvent(event.eventId, event.betId);
      add(LoadEventsEvent());
      if (event.callback != null) {
        await event.callback!();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
