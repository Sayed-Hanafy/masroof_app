import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/features/auth/data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState());

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: EnumAuthStatus.loading, message: null));

    try {
      final response = await authRepository.login(
        email: email,
        password: password,
      );

      if (response.status && response.user != null) {
        emit(
          state.copyWith(
            status: EnumAuthStatus.authenticated,
            user: response.user,
            message: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EnumAuthStatus.failure,
            message: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EnumAuthStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: EnumAuthStatus.loading, message: null));

    try {
      final response = await authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      if (response.status) {
        emit(
          state.copyWith(
            status: EnumAuthStatus.success,
            message: response.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EnumAuthStatus.failure,
            message: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EnumAuthStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void checkAuthStatus() {
    emit(state.copyWith(status: EnumAuthStatus.checking));
    final isLoggedIn = authRepository.isLoggedIn();

    if (isLoggedIn) {
      final user = authRepository.getUser();
      emit(state.copyWith(status: EnumAuthStatus.authenticated, user: user));
    } else {
      emit(state.copyWith(status: EnumAuthStatus.unauthenticated));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      emit(
        state.copyWith(
          status: EnumAuthStatus.unauthenticated,
          user: null,
          message: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EnumAuthStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
