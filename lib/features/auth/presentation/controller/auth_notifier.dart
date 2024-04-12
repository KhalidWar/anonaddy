import 'dart:async';

import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:anonaddy/features/auth/data/biometric_auth_service.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/auth/presentation/controller/biometric_notifier.dart';
import 'package:anonaddy/features/monetization/presentation/controller/monetization_notifier.dart';
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
  Future<void> loginWithAccessToken(String url, String token) async {
    final currentState = state.value!;
    try {
      state = AsyncData(currentState.copyWith(loginLoading: true));

      final user =
          await ref.read(authServiceProvider).loginWithAccessToken(url, token);
      await ref.read(authServiceProvider).saveUser(user);

      state = AsyncData(
        currentState.copyWith(
          isLoggedIn: true,
          user: user,
          loginLoading: false,
        ),
      );
    } catch (error) {
      Utilities.showToast(error.toString());
      state = AsyncData(state.value!.copyWith(loginLoading: false));
    }
  }

  Future<void> loginWithUsernameAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await ref
          .read(authServiceProvider)
          .loginWithUsernameAndPassword(email, password);

      await ref.read(authServiceProvider).saveUser(user);
      state = AsyncData(state.value!.copyWith(isLoggedIn: true, user: user));
    } catch (error) {
      Utilities.showToast(error.toString());
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
          isLoggedIn: state.value!.isLoggedIn,
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
  Future<bool> _isLoginCredentialValid(User? user) async {
    try {
      if (user == null) return false;
      if (user.hasTokenExpired) return false;
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

  @override
  FutureOr<AuthState> build() async {
    final user = await ref.read(authServiceProvider).getUser();
    final isLoginCredentialValid = await _isLoginCredentialValid(user);
    final authStatus = await _getBioAuthState();

    if (isLoginCredentialValid) {
      if (user!.isSelfHosting) {
        final showPaywall = await ref.read(monetizationNotifierProvider.future);
        if (showPaywall) {
          return AuthState(
            isLoggedIn: false,
            authenticationStatus: authStatus,
            loginLoading: false,
          );
        }
      }

      return AuthState(
        isLoggedIn: true,
        authenticationStatus: authStatus,
        loginLoading: false,
        user: user,
      );
    }

    return AuthState(
      isLoggedIn: false,
      authenticationStatus: authStatus,
      loginLoading: false,
    );
  }
}
