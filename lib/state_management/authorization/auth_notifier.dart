import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/state_management/biometric_auth/biometric_notifier.dart';
import 'package:anonaddy/state_management/search/search_history_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_state.dart';

final authStateNotifier = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  final bioService = ref.read(biometricAuthService);
  final tokenService = ref.read(accessTokenService);
  final searchHistory = ref.read(searchHistoryStateNotifier.notifier);
  final showToast = ref.read(nicheMethods).showToast;
  return AuthNotifier(
    secureStorage: secureStorage,
    biometricService: bioService,
    tokenService: tokenService,
    searchHistory: searchHistory,
    showToast: showToast,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.secureStorage,
    required this.biometricService,
    required this.tokenService,
    required this.searchHistory,
    required this.showToast,
  }) : super(AuthState(
          authStatus: AuthStatus.initial,
          authLock: AuthLock.off,
          loginLoading: false,
        )) {
    _initAuth();
  }

  final FlutterSecureStorage secureStorage;
  final BiometricAuthService biometricService;
  final AccessTokenService tokenService;
  final SearchHistoryNotifier searchHistory;
  final Function showToast;

  Future<void> login(String url, String token) async {
    state = state.copyWith(loginLoading: true);
    try {
      final isTokenValid = await tokenService.validateAccessToken(url, token);

      if (isTokenValid) {
        await tokenService.saveLoginCredentials(url, token);
        state = state.copyWith(
            authStatus: AuthStatus.authorized, loginLoading: false);
      }
    } catch (error) {
      state = state.copyWith(loginLoading: false);
      showToast(error.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await secureStorage.deleteAll();
      await searchHistory.clearSearchHistory();
      Phoenix.rebirth(context);
      state = AuthState.freshStart();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> authenticate() async {
    try {
      final didAuth = await biometricService.authenticate();
      if (didAuth) {
        state = state.copyWith(
          authStatus: state.authStatus,
          authLock: AuthLock.off,
        );
      } else {
        state = state.copyWith(errorMessage: 'Failed to authenticate!');
        showToast('Failed to authenticate!');
      }
    } catch (error) {
      state =
          state.copyWith(errorMessage: 'Authorization failed! Log in again!');
    }
  }

  Future<void> _initAuth() async {
    await biometricService.init();
    final accessToken = await tokenService.getAccessToken();
    final bioAuthKey = BiometricNotifier.biometricAuthKey;
    final bioKeyValue = await secureStorage.read(key: bioAuthKey);

    if (accessToken.isEmpty) {
      /// Fresh start after user logs out or AccessToken isn't found
      state = AuthState.freshStart();
    } else {
      //todo validate accessToken and return unauthorized if it fails
      state = state.copyWith(
        authStatus: AuthStatus.authorized,
        authLock: _initBioAuth(bioKeyValue),
      );
    }
  }

  AuthLock _initBioAuth(String? input) {
    if (input == null) {
      return AuthLock.off;
    } else {
      return input == 'true' ? AuthLock.on : AuthLock.off;
    }
  }
}
