import 'package:equatable/equatable.dart';
import 'package:masroof_app/features/auth/data/models/user_model.dart';

enum EnumAuthStatus {
  initial,
  checking,
  loading,
  authenticated,
  unauthenticated,
  failure,
  success,
}

const _undefined = Object();

class AuthState extends Equatable {
  final EnumAuthStatus status;
  final UserModel? user;
  final String? message;

  const AuthState({
    this.status = EnumAuthStatus.initial,
    this.user,
    this.message,
  });

  AuthState copyWith({
    EnumAuthStatus? status,
    Object? user = _undefined,
    Object? message = _undefined,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user == _undefined ? this.user : user as UserModel?,
      message: message == _undefined ? this.message : message as String?,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
