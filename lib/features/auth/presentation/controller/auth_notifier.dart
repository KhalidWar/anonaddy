import 'dart:async';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/auth/data/auth_service.dart';
import 'package:anonaddy/features/auth/data/biometric_auth_service.dart';
import 'package:anonaddy/features/auth/domain/user.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/auth/presentation/controller/biometric_notifier.dart';
import 'package:anonaddy/features/monetization/presentation/controller/monetization_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AuthState> {
  Future<bool> loginWithAccessToken(String url, String token) async {
    try {
      final currentState = state.value!;

      final user =
          await ref.read(authServiceProvider).loginWithAccessToken(url, token);
      await ref.read(authServiceProvider).saveUser(user);

      state = AsyncData(
        currentState.copyWith(isLoggedIn: true, user: user),
      );
      return true;
    } catch (error) {
      Utilities.showToast(error.toString());
      return false;
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

      state = AsyncData(
        state.value!.copyWith(
          isLoggedIn: true,
          user: user,
        ),
      );
    } catch (error) {
      Utilities.showToast(error.toString());
      return;
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(flutterSecureStorageProvider).deleteAll();
      state = AsyncData(AuthState.initial());
    } catch (error) {
      Utilities.showToast(error.toString());
      return;
    }
  }

  Future<void> authenticate() async {
    try {
      final didAuthenticate =
          await ref.read(biometricAuthServiceProvider).authenticate();
      if (didAuthenticate) {
        final currentState = state.value!;

        state = AsyncData(
          currentState.copyWith(
            isLoggedIn: currentState.isLoggedIn,
            isBiometricLocked: false,
          ),
        );
        return;
      }

      Utilities.showToast(AppStrings.failedToAuthenticate);
    } catch (error) {
      Utilities.showToast(error.toString());
      return;
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
      return false;
    }
  }

  Future<bool> _getBioAuthState() async {
    try {
      const bioAuthKey = BiometricNotifier.biometricAuthKey;
      final bioAuthValue =
          await ref.read(flutterSecureStorageProvider).read(key: bioAuthKey);

      if (bioAuthValue == null) return false;

      return bioAuthValue == 'true';
    } catch (error) {
      return false;
    }
  }

  @override
  FutureOr<AuthState> build() async {
    final user = await ref.read(authServiceProvider).getUser();
    final isLoginCredentialValid = await _isLoginCredentialValid(user);

    /// When user is logged in and token is not expired
    if (isLoginCredentialValid) {
      /// If user is self-hosting, check whether they have a subscription
      if (user!.isSelfHosting) {
        final showPaywall = await ref.read(monetizationNotifierProvider.future);

        /// If self-hosted user has no subscription, log them out
        /// so that they can buy subscription when logging in.
        if (showPaywall) {
          return AuthState.initial();
        }
      }

      /// If user is logged in and token is not expired
      /// or user is self-hosting and has a subscription
      /// check whether biometric authentication is enabled
      /// and proceed to the app.
      return AuthState(
        isLoggedIn: true,
        isBiometricLocked: await _getBioAuthState(),
        user: user,
      );
    }

    /// If user is not logged in or token is expired
    return AuthState.initial();
  }
}
