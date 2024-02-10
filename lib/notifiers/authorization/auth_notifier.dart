import 'dart:async';

import 'package:anonaddy/notifiers/authorization/auth_state.dart';
import 'package:anonaddy/notifiers/biometric_auth/biometric_notifier.dart';
import 'package:anonaddy/notifiers/search/search_history/search_history_notifier.dart';
import 'package:anonaddy/services/access_token/auth_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateNotifier =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AuthState> {
  void goToAnonAddyLogin() {
    state = AsyncData(state.value!.copyWith(
      authorizationStatus: AuthorizationStatus.anonAddyLogin,
    ));
  }

  void goToSelfHostedLogin() {
    state = AsyncData(state.value!.copyWith(
      authorizationStatus: AuthorizationStatus.selfHostedLogin,
    ));
  }

  Future<void> login(String url, String token) async {
    state = AsyncData(state.value!.copyWith(loginLoading: true));

    try {
      final apiToken =
          await ref.read(authServiceProvider).fetchApiTokenData(url, token);

      await ref.read(authServiceProvider).saveLoginCredentials(url, token);
      state = AsyncData(state.value!.copyWith(
        authorizationStatus: AuthorizationStatus.authorized,
        loginLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(loginLoading: false));
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await ref.read(flutterSecureStorage).deleteAll();
      await ref.read(searchHistoryStateNotifier.notifier).clearSearchHistory();
      if (context.mounted) Phoenix.rebirth(context);
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  Future<void> authenticate() async {
    try {
      final didAuth =
          await ref.read(biometricAuthServiceProvider).authenticate();
      if (didAuth) {
        state = AsyncData(state.value!.copyWith(
          authorizationStatus: state.value!.authorizationStatus,
          authenticationStatus: AuthenticationStatus.disabled,
        ));
      } else {
        // state = AsyncData(state.value!
        //     .copyWith(errorMessage: AppStrings.failedToAuthenticate));
        Utilities.showToast(AppStrings.failedToAuthenticate);
      }
    } catch (error) {
      // state = AsyncData(state.value!.copyWith(
      //   errorMessage: 'Authorization failed! Log in again!',
      // ));

      state = const AsyncError(
        'Authorization failed! Log in again!',
        StackTrace.empty,
      );
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
  Future<void> _initAuth() async {
    try {
      final isLoginValid = await _validateLoginCredential();
      final authStatus = await _getBioAuthState();

      if (isLoginValid) {
        state = AsyncData(state.value!.copyWith(
          authorizationStatus: AuthorizationStatus.authorized,
          authenticationStatus: authStatus,
        ));
      } else {
        state = AsyncData(state.value!.copyWith(
          authorizationStatus: AuthorizationStatus.anonAddyLogin,
          authenticationStatus: authStatus,
        ));
      }
    } catch (error) {
      Utilities.showToast(error.toString());

      /// Authenticate user regardless of error.
      /// This is a temp solution until I'm able to handle different errors.
      state = AsyncData(state.value!.copyWith(
        authorizationStatus: AuthorizationStatus.anonAddyLogin,
      ));
    }
  }

  /// Fetches and validates stored login credentials
  /// and returns bool if valid or not
  Future<bool> _validateLoginCredential() async {
    try {
      final token = await ref.read(authServiceProvider).getAccessToken();
      final url = await ref.read(authServiceProvider).getInstanceURL();
      if (token.isEmpty || url.isEmpty) return false;

      /// Temporarily override token and url validation check until I find
      /// a way of handling different errors.
      return true;

      // final isValid = await ref.read(accessTokenServiceProvider).validateAccessToken(url, token);
      // return isValid;
    } catch (error) {
      rethrow;
    }
  }

  Future<AuthenticationStatus> _getBioAuthState() async {
    try {
      const bioAuthKey = BiometricNotifier.biometricAuthKey;
      final bioAuthValue =
          await ref.read(flutterSecureStorage).read(key: bioAuthKey);

      if (bioAuthValue == null) return AuthenticationStatus.disabled;

      return bioAuthValue == 'true'
          ? AuthenticationStatus.enabled
          : AuthenticationStatus.disabled;
    } catch (error) {
      return AuthenticationStatus.disabled;
    }
  }

  @override
  FutureOr<AuthState> build() async {
    final secureStorage = ref.read(flutterSecureStorage);
    final biometricAuth = ref.read(biometricAuthServiceProvider);
    final tokenService = ref.read(authServiceProvider);
    final searchHistory = ref.read(searchHistoryStateNotifier);

    final isLoginValid = await _validateLoginCredential();
    final authStatus = await _getBioAuthState();

    if (isLoginValid) {
      return AuthState(
        authorizationStatus: AuthorizationStatus.authorized,
        authenticationStatus: authStatus,
        loginLoading: false,
      );
    }

    return AuthState(
      authorizationStatus: AuthorizationStatus.anonAddyLogin,
      authenticationStatus: authStatus,
      loginLoading: false,
    );
  }
}
