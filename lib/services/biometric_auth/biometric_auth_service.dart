import 'dart:developer';

import 'package:anonaddy/shared_components/constants/constants_exports.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService(localAuth: LocalAuthentication());
});

class BiometricAuthService {
  const BiometricAuthService({required this.localAuth});
  final LocalAuthentication localAuth;

  Future<bool> authenticate() async {
    try {
      final supportsBioAuth = await _doesDeviceSupportBioAuth();
      if (supportsBioAuth) {
        return await _authenticate();
      } else {
        return false;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> _doesDeviceSupportBioAuth() async {
    try {
      return await localAuth.canCheckBiometrics;
    } catch (error) {
      throw AppStrings.deviceDoesNotSupportBioAuth;
    }
  }

  Future<bool> _authenticate() async {
    try {
      return await localAuth.authenticate(
        localizedReason: ToastMessage.authToProceed,
      );
    } on PlatformException catch (e) {
      log('BiometricAuthService _authenticate: ${e.toString()}');
      if (e.code == auth_error.notAvailable) {
        throw e.message ?? AppStrings.deviceDoesNotSupportBioAuth;
      }
      throw e.message ?? AppStrings.somethingWentWrong;
    } catch (error) {
      throw AppStrings.failedToAuthenticate;
    }
  }
}
