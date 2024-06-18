import 'package:anonaddy/features/auth/domain/user.dart';

class AuthState {
  const AuthState({
    required this.isBiometricLocked,
    this.user,
  });

  factory AuthState.initial() {
    return const AuthState(
      isBiometricLocked: false,
      user: null,
    );
  }

  final bool isBiometricLocked;
  final User? user;

  @override
  String toString() {
    return 'AuthState{isBiometricLocked: $isBiometricLocked, user: $user}';
  }

  AuthState copyWith({
    bool? isBiometricLocked,
    User? user,
  }) {
    return AuthState(
      isBiometricLocked: isBiometricLocked ?? this.isBiometricLocked,
      user: user ?? this.user,
    );
  }
}
