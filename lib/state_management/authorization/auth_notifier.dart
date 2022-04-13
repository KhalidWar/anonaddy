import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/state_management/authorization/auth_state.dart';
import 'package:anonaddy/state_management/biometric_auth/biometric_notifier.dart';
import 'package:anonaddy/state_management/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authStateNotifier = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    secureStorage: ref.read(flutterSecureStorage),
    biometricService: ref.read(biometricAuthServiceProvider),
    tokenService: ref.read(accessTokenServiceProvider),
    searchHistory: ref.read(searchHistoryStateNotifier.notifier),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.secureStorage,
    required this.biometricService,
    required this.tokenService,
    required this.searchHistory,
  }) : super(AuthState.initialState());

  final FlutterSecureStorage secureStorage;
  final BiometricAuthService biometricService;
  final AccessTokenService tokenService;
  final SearchHistoryNotifier searchHistory;

  void _updateState(AuthState newState) {
    if (mounted) state = newState;
  }

  void goToAnonAddyLogin() {
    final newState = state.copyWith(
      authorizationStatus: AuthorizationStatus.anonAddyLogin,
    );
    _updateState(newState);
  }

  void goToSelfHostedLogin() {
    final newState = state.copyWith(
      authorizationStatus: AuthorizationStatus.selfHostedLogin,
    );
    _updateState(newState);
  }

  Future<void> login(String url, String token) async {
    _updateState(state.copyWith(loginLoading: true));

    try {
      final isTokenValid = await tokenService.validateAccessToken(url, token);

      if (isTokenValid) {
        await tokenService.saveLoginCredentials(url, token);
        final newState = state.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          loginLoading: false,
        );
        _updateState(newState);
      }
    } catch (error) {
      final newState = state.copyWith(loginLoading: false);
      NicheMethod.showToast(error.toString());
      _updateState(newState);
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await secureStorage.deleteAll();
      await searchHistory.clearSearchHistory();
      Phoenix.rebirth(context);
    } catch (error) {
      NicheMethod.showToast(error.toString());
    }
  }

  Future<void> authenticate() async {
    try {
      final didAuth = await biometricService.authenticate();
      if (didAuth) {
        final newState = state.copyWith(
          authorizationStatus: state.authorizationStatus,
          authenticationStatus: AuthenticationStatus.disabled,
        );
        _updateState(newState);
      } else {
        final newState =
            state.copyWith(errorMessage: 'Failed to authenticate!');
        _updateState(newState);
        NicheMethod.showToast('Failed to authenticate!');
      }
    } catch (error) {
      final newState =
          state.copyWith(errorMessage: 'Authorization failed! Log in again!');
      _updateState(newState);
    }
  }

  /// Manages authentication flow at app startup.
  ///   1. Fetches stored access token and instance url.
  ///   2. Attempts to login to check if token and url are valid.
  ///   3. If valid, set [state] to [AuthorizationStatus.authorized].
  ///   4. If invalid, set [state] to [AuthorizationStatus.unauthorized].
  ///
  /// It also checks if user's device supports biometric authentication.
  /// Then sets [state] accordingly.
  Future<void> initAuth() async {
    try {
      final isLoginValid = await _validateLoginCredential();
      final canCheck = await biometricService.doesPlatformSupportAuth();
      final authStatus = await _getBioAuthState();

      if (isLoginValid) {
        final newState = state.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          authenticationStatus:
              canCheck ? authStatus : AuthenticationStatus.unavailable,
        );
        _updateState(newState);
      } else {
        final newState = state.copyWith(
          authorizationStatus: AuthorizationStatus.anonAddyLogin,
          authenticationStatus:
              canCheck ? authStatus : AuthenticationStatus.unavailable,
        );
        _updateState(newState);
      }
    } catch (error) {
      NicheMethod.showToast(error.toString());
    }
  }

  /// Fetches and validates stored login credentials
  /// and returns bool if valid or not
  Future<bool> _validateLoginCredential() async {
    try {
      final token = await tokenService.getAccessToken();
      final url = await tokenService.getInstanceURL();
      if (token.isEmpty || url.isEmpty) return false;

      final isValid = await tokenService.validateAccessToken(url, token);
      return isValid;
    } catch (error) {
      rethrow;
    }
  }

  Future<AuthenticationStatus> _getBioAuthState() async {
    try {
      const bioAuthKey = BiometricNotifier.biometricAuthKey;
      final bioAuthValue = await secureStorage.read(key: bioAuthKey);

      if (bioAuthValue == null) return AuthenticationStatus.disabled;

      return bioAuthValue == 'true'
          ? AuthenticationStatus.enabled
          : AuthenticationStatus.disabled;
    } catch (error) {
      rethrow;
    }
  }
}
