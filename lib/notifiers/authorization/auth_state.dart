/// Manages user flow status
enum AuthorizationStatus {
  /// Default status at app startup when user data hasn't been fetched yet.
  unknown,

  /// When user decides to log in with addy.io account.
  anonAddyLogin,

  /// When user decides to log in with a self hosted instance.
  selfHostedLogin,

  /// When user logs in successfully and/or user account has been fetched from
  /// device storage.
  authorized,
}

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
    required this.loginLoading,
  });

  final AuthorizationStatus authorizationStatus;
  final AuthenticationStatus authenticationStatus;
  final bool loginLoading;

  @override
  String toString() {
    return 'AuthState{authorizationStatus: $authorizationStatus, authenticationStatus: $authenticationStatus, loginLoading: $loginLoading}';
  }

  AuthState copyWith({
    AuthorizationStatus? authorizationStatus,
    AuthenticationStatus? authenticationStatus,
    bool? loginLoading,
  }) {
    return AuthState(
      authorizationStatus: authorizationStatus ?? this.authorizationStatus,
      authenticationStatus: authenticationStatus ?? this.authenticationStatus,
      loginLoading: loginLoading ?? this.loginLoading,
    );
  }
}
