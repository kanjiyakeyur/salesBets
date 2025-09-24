// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

// Project imports:
import '../../../../core/app_export.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../data/models/applicationVersion/applicationVersion.dart';
import '../models/splash_model.dart';

part 'splash_event.dart';

part 'splash_state.dart';

/// A bloc that manages the state of a Splash according to the event that is dispatched to it.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(SplashState initialState) : super(initialState) {
    on<SplashInitialEvent>(_onInitialize);
  }

  _onInitialize(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    var delay = Future.delayed(const Duration(milliseconds: 2000));
    event.context.read<UserBloc>().add(InitialUserEvent(
      callback: (){
        delay.whenComplete((){
          NavigatorService.callHomeScreen();
        });
      }
    ));


    // if (PrefUtils().isUserAuthenticate()) {
    //   Future.delayed(const Duration(milliseconds: 2000), () {
    //     callHomeScreen();
    //   });
    // } else {
    //   Future.delayed(const Duration(milliseconds: 2000), () {
    //     callHomeScreen();
    //   });
    // }
  }


}
