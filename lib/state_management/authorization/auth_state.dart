enum AuthStatus { initial, authorized, unauthorized }
enum AuthLock { on, off }

class AuthState {
  const AuthState({
    required this.authStatus,
    required this.authLock,
    this.errorMessage,
  });

  final AuthStatus authStatus;
  final AuthLock authLock;
  final String? errorMessage;

  @override
  String toString() {
    return 'AuthState( authStatus: $authStatus, bioStatus: $authLock, errorMessage: $errorMessage )';
  }
}
