// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import '../../../core/app_export.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc(DashBoardState initialState) : super(initialState) {
    on<InitEvent>(_onInit);
  }

  _onInit(
    InitEvent event,
    Emitter<DashBoardState> emit,
  ) async {
    // Logic come here for init
    // emit(state.copyWith(themeType: event.themeType));
  }
}
