import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/state_management/biometric_auth/biometric_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_state.dart';

final authStateNotifier = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  final bioService = ref.read(biometricAuthService);
  final tokenService = ref.read(accessTokenService);
  final showToast = ref.read(nicheMethods).showToast;
  return AuthNotifier(
    secureStorage: secureStorage,
    biometricService: bioService,
    tokenService: tokenService,
    showToast: showToast,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.secureStorage,
    required this.biometricService,
    required this.tokenService,
    required this.showToast,
  }) : super(AuthState(
          authStatus: AuthStatus.initial,
          authLock: AuthLock.off,
        )) {
    _initAuth();
  }

  final FlutterSecureStorage secureStorage;
  final BiometricAuthService biometricService;
  final AccessTokenService tokenService;
  final Function showToast;

  Future<void> authenticate() async {
    try {
      final didAuth = await biometricService.authenticate();
      if (didAuth) {
        state = AuthState(
          authStatus: state.authStatus,
          authLock: AuthLock.off,
        );
      } else {
        state = AuthState(
          authStatus: state.authStatus,
          authLock: state.authLock,
          errorMessage: 'Failed to authenticate!',
        );
        showToast('Failed to authenticate!');
      }
    } catch (error) {
      state = AuthState(
        authStatus: state.authStatus,
        authLock: state.authLock,
        errorMessage: 'Authorization failed! Log in again!',
      );
    }
  }

  Future<void> _initAuth() async {
    await biometricService.init();
    final accessToken = await tokenService.getAccessToken();
    final bioAuthKey = BiometricNotifier.biometricAuthKey;
    final bioKeyValue = await secureStorage.read(key: bioAuthKey);

    if (accessToken.isEmpty) {
      /// Fresh start after user logs out or AccessToken isn't found
      state = AuthState(
        authStatus: AuthStatus.unauthorized,
        authLock: _initBioAuth(bioKeyValue),
        errorMessage: 'Authorization failed! Log in again!',
      );
    } else {
      //todo validate accessToken and return unauthorized if it fails
      state = AuthState(
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
