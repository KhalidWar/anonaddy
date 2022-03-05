import 'package:anonaddy/screens/authorization_screen/authorization_screen.dart';

/// Manages user flow status
enum AuthorizationStatus { unknown, authorized, unauthorized }

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
    required this.authorizationStatus,
    required this.authenticationStatus,
    this.errorMessage,
    this.loginLoading,
  });

  final AuthorizationStatus authorizationStatus;
  final AuthenticationStatus authenticationStatus;
  final String? errorMessage;
  final bool? loginLoading;

  /// Sets initial state for [AuthorizationScreen]
  static AuthState initialState() {
    return const AuthState(
      authorizationStatus: AuthorizationStatus.unknown,
      authenticationStatus: AuthenticationStatus.unavailable,
      loginLoading: false,
      errorMessage: '',
    );
  }

  AuthState copyWith({
    AuthorizationStatus? authorizationStatus,
    AuthenticationStatus? authenticationStatus,
    String? errorMessage,
    bool? loginLoading,
  }) {
    return AuthState(
      authorizationStatus: authorizationStatus ?? this.authorizationStatus,
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      loginLoading: loginLoading ?? this.loginLoading,
    );
  }

  @override
  String toString() {
    return 'AuthState{authorizationStatus: $authorizationStatus, authenticationStatus: $authenticationStatus, errorMessage: $errorMessage, loginLoading: $loginLoading}';
  }
}
