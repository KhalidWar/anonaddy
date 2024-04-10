import 'package:anonaddy/features/auth/domain/user.dart';

/// Manages app biometric authentication lock status.
enum AuthenticationStatus {
  /// When user has enabled biometric auth and app requires biometric
  /// unlock at next app startup.
  enabled,

  /// When user hasn't set up or enabled biometric authentication
  disabled,

  /// When current platform doesn't support biometric authentication.
  /// At the moment, local auth doesn't support MacOS.
  unavailable,
}

class AuthState {
  const AuthState({
    required this.isLoggedIn,
    required this.authenticationStatus,
    required this.loginLoading,
    this.user,
  });

  final bool isLoggedIn;
  final AuthenticationStatus authenticationStatus;
  final bool loginLoading;
  final User? user;

  @override
  String toString() {
    return 'AuthState{isLoggedIn: $isLoggedIn, authenticationStatus: $authenticationStatus, loginLoading: $loginLoading, user: $user}';
  }

  AuthState copyWith({
    bool? isLoggedIn,
    AuthenticationStatus? authenticationStatus,
    bool? loginLoading,
    User? user,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
      loginLoading: loginLoading ?? this.loginLoading,
      user: user ?? this.user,
    );
  }
}
