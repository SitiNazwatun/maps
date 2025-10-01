import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositorie/auth_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<cekAutoLogin>(_onCheckAutoLogin);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
    on<RefreshTokenRequested>(_onRefreshTokenRequested);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.login(event.username, event.password);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthGagal(error: e.toString()));
    }
  }

  Future<void> _onCheckAutoLogin(
      cekAutoLogin event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.cekAutoLogin(); //manggil authrepo
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthLoggedOut());
    }
  }

  Future<void> _onLogoutButtonPressed(
      LogoutButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    await authRepo.logout();
    emit(AuthLoggedOut());
  }

  Future<void> _onRefreshTokenRequested(
      RefreshTokenRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final user = await authRepo.refreshToken();
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthLoggedOut());
    }
  }
}



