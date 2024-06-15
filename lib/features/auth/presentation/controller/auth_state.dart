import 'package:anonaddy/features/auth/domain/user.dart';

class AuthState {
  const AuthState({
    required this.isLoggedIn,
    required this.isBiometricLocked,
    this.user,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoggedIn: false,
      isBiometricLocked: false,
      user: null,
    );
  }

  final bool isLoggedIn;
  final bool isBiometricLocked;
  final User? user;

  @override
  String toString() {
    return 'AuthState{isLoggedIn: $isLoggedIn, isBiometricLocked: $isBiometricLocked, user: $user}';
  }

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isBiometricLocked,
    User? user,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isBiometricLocked: isBiometricLocked ?? this.isBiometricLocked,
      user: user ?? this.user,
    );
  }
}
