part of 'user_bloc.dart';

class UserState extends Equatable {
  UserState({
    this.isAuthenticated,
    this.user,
  });

  bool? isAuthenticated;
  final User? user;

  @override
  List<Object?> get props => [
    isAuthenticated,
    user,
  ];

  UserState copyWith({
    bool? isAuthenticated,
    User? user,
    bool removeUser = false,
  }) {
    return UserState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: removeUser ? null : user ?? this.user,
    );
  }
}
