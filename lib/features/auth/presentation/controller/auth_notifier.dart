import 'dart:async';

import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:anonaddy/features/auth/data/biometric_auth_service.dart';
import 'package:anonaddy/features/auth/domain/api_token.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/auth/presentation/controller/biometric_notifier.dart';
import 'package:anonaddy/features/search/presentation/controller/search_history_notifier.dart';
import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:anonaddy/utilities/flutter_secure_storage.dart';
import 'package:anonaddy/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateNotifier =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AuthState> {
  void goToAddyLogin() {
    state = AsyncData(state.value!.copyWith(
      authorizationStatus: AuthorizationStatus.addyLogin,
    ));
  }

  void goToSelfHostedLogin() {
    state = AsyncData(state.value!.copyWith(
      authorizationStatus: AuthorizationStatus.selfHostedLogin,
    ));
  }

  Future<void> login(String url, String token) async {
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(loginLoading: true));
    }

    try {
      final apiToken =
          await ref.read(authServiceProvider).fetchApiTokenData(url, token);
      final user = User(url: url, token: token, apiToken: apiToken);

      await ref.read(authServiceProvider).saveUser(user);
      state = AsyncData(state.value!.copyWith(
        authorizationStatus: AuthorizationStatus.authorized,
        loginLoading: false,
      ));
    } catch (error) {
      Utilities.showToast(error.toString());
      if (state.value != null) {
        state = AsyncData(state.value!.copyWith(loginLoading: false));
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await ref.read(flutterSecureStorage).deleteAll();
      await ref
          .read(searchHistoryNotifierProvider.notifier)
          .clearSearchHistory();
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
        return;
      }

      Utilities.showToast(AppStrings.failedToAuthenticate);
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  /// Fetches and validates stored login credentials
  /// and returns bool if valid or not
  Future<bool> _isLoginCredentialValid() async {
    try {
      final user = await ref.read(authServiceProvider).getUser();
      if (user == null) return false;
      if (user.apiToken.isExpired) return false;
      return true;
    } catch (error) {
      Utilities.showToast(error.toString());
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

  Future<bool> _doesOldLoginExist() async {
    try {
      final url = await ref
          .read(flutterSecureStorage)
          .read(key: SecureStorageKeys.instanceURLKey);
      final token = await ref
          .read(flutterSecureStorage)
          .read(key: SecureStorageKeys.accessTokenKey);

      if (url == null || token == null) return false;

      final apiToken =
          await ref.read(authServiceProvider).fetchApiTokenData(url, token);
      final user = User(url: url, token: token, apiToken: apiToken);
      await ref.read(authServiceProvider).saveUser(user);

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  FutureOr<AuthState> build() async {
    final isLoginCredentialValid = await _isLoginCredentialValid();
    final authStatus = await _getBioAuthState();

    if (isLoginCredentialValid) {
      return AuthState(
        authorizationStatus: AuthorizationStatus.authorized,
        authenticationStatus: authStatus,
        loginLoading: false,
      );
    }

    final oldLoginCredentialExists = await _doesOldLoginExist();
    if (oldLoginCredentialExists) {
      return AuthState(
        authorizationStatus: AuthorizationStatus.authorized,
        authenticationStatus: authStatus,
        loginLoading: false,
      );
    }

    return AuthState(
      authorizationStatus: AuthorizationStatus.addyLogin,
      authenticationStatus: authStatus,
      loginLoading: false,
    );
  }
}
