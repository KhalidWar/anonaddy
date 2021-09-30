enum AuthStatus { initial, authorized, unauthorized }
enum AuthLock { on, off }

class AuthState {
  const AuthState({
    required this.authStatus,
    required this.authLock,
    this.errorMessage,
    this.loginLoading,
  });

  final AuthStatus authStatus;
  final AuthLock authLock;
  final String? errorMessage;
  final bool? loginLoading;

  static freshStart() {
    return AuthState(
      authStatus: AuthStatus.unauthorized,
      authLock: AuthLock.off,
      loginLoading: false,
    );
  }

  AuthState copyWith({
    AuthStatus? authStatus,
    AuthLock? authLock,
    String? errorMessage,
    bool? loginLoading,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      authLock: authLock ?? this.authLock,
      errorMessage: errorMessage ?? this.errorMessage,
      loginLoading: loginLoading ?? this.loginLoading,
    );
  }

  @override
  String toString() {
    return 'authStatus: $authStatus, bioStatus: $authLock, errorMessage: $errorMessage, loginLoading: $loginLoading';
  }
}
