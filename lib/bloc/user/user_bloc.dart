// Project imports:
import '../../core/app_export.dart';
import '../../core/utils/hive_database_handler.dart';
import '../../data/models/user/user.dart';
import '../../data/models/verifyOtp/post_verify_otp_resp.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  UserBloc(super.initialState) {

    on<InitialUserEvent>(_onInitialize);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<SalesBetLoginEvent>(_onSalesBetLogin);
  }

  _onInitialize(InitialUserEvent event, Emitter<UserState> emit) async {
    // Initialize the user state, possibly fetching user data from a repository or service
    final user = await PrefUtils().getUserData();
    final token = await PrefUtils().getToken();
    final isAuthenticated = (token == '') ? false : true;

    print(user?.email);
    print(user?.id);
    print(token);
    print(isAuthenticated);

    emit(
      state.copyWith(
        isAuthenticated: (token == '') ? false : true,
        user: user,
      ),
    );



    if (event.callback != null) {
      await event.callback!();
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<UserState> emit) async {
    await PrefUtils().setUserData(event.postVerifyOtpResp.user);
    await PrefUtils().setToken(event.postVerifyOtpResp.token ?? '');
    emit(
      state.copyWith(isAuthenticated: true, user: event.postVerifyOtpResp.user),
    );
    if (event.callback != null) {
      await event.callback!();
    }
  }




  Future<void> _onLogout(LogoutEvent event, Emitter<UserState> emit) async {
    await PrefUtils().clearPreferencesData();
    await HiveDatabaseHandler().clearHiveDatabase();

    emit(
      state.copyWith(
        removeUser: true,
        isAuthenticated: false,
      ),
    );
    if (event.callback != null) {
      await event.callback!();
    }
    NavigatorService.pushNamedAndRemoveUntil(AppRoutes.authScreen);
  }

  Future<void> _onSalesBetLogin(SalesBetLoginEvent event, Emitter<UserState> emit) async {
    // Store sales bet user data in preferences
    // For now, we'll just store basic info - can be extended later
    await PrefUtils().setToken('authenticated'); // Simple token for now

    emit(
      state.copyWith(
        isAuthenticated: true,
        // We'll store the SalesBetUser as the user for now
        // In the future, we might want to convert it to the existing User model
      ),
    );

    if (event.callback != null) {
      await event.callback!();
    }
  }

}
