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
    biometricService: ref.read(biometricAuthService),
    tokenService: ref.read(accessTokenService),
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

  /// Initializes
  Future<void> initAuth() async {
    try {
      final accessToken = await tokenService.getAccessToken();
      const bioAuthKey = BiometricNotifier.biometricAuthKey;
      final bioKeyValue = await secureStorage.read(key: bioAuthKey);

      /// When a logged in is NOT found
      if (accessToken.isEmpty) {
        final newState = state.copyWith(
            authorizationStatus: AuthorizationStatus.unauthorized);
        _updateState(newState);
      } else {
        /// When a logged in is NOT found
        //todo validate accessToken and return unauthorized if it fails
        final canCheck = await biometricService.doesPlatformSupportAuth();
        final savedAuthStatus = _initBioAuth(bioKeyValue);

        final newState = state.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          authenticationStatus:
              canCheck ? savedAuthStatus : AuthenticationStatus.unavailable,
        );
        _updateState(newState);
      }
    } catch (error) {
      rethrow;
    }
  }

  AuthenticationStatus _initBioAuth(String? input) {
    if (input == null) {
      return AuthenticationStatus.disabled;
    }

    if (input == 'true') {
      return AuthenticationStatus.enabled;
    } else {
      return AuthenticationStatus.disabled;
    }
  }
}
