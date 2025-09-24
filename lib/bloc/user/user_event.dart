part of 'user_bloc.dart';

class UserEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialUserEvent extends UserEvent {
  InitialUserEvent({this.callback});
  final Function? callback;
  @override
  List<Object?> get props => [];
}


class LoginEvent extends UserEvent {
  LoginEvent({this.callback, required this.postVerifyOtpResp});
  final Function? callback;
  final PostVerifyOtpResp postVerifyOtpResp;
  @override
  List<Object?> get props => [callback, postVerifyOtpResp];
}

class LogoutEvent extends UserEvent {
  LogoutEvent({this.callback});
  final Function? callback;
  @override
  List<Object?> get props => [callback];
}

class SalesBetLoginEvent extends UserEvent {
  SalesBetLoginEvent({this.callback, required this.user});
  final Function? callback;
  final dynamic user; // SalesBetUser
  @override
  List<Object?> get props => [callback, user];
}