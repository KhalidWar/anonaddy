import 'dart:developer';

import 'package:anonaddy/shared_components/constants/toast_message.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  const BiometricAuthService(this.localAuth);
  final LocalAuthentication localAuth;

  Future<void> init() async {
    try {
      await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      throw e.message ?? 'Failed to authenticate';
    }
  }

  Future<bool> doesPlatformSupportAuth() async {
    try {
      return await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      throw e.message ?? 'Failed to authenticate';
    }
  }

  Future<bool> authenticate() async {
    final canCheckBio = await localAuth.canCheckBiometrics;
    if (canCheckBio) {
      try {
        return await localAuth.authenticate(
          localizedReason: ToastMessage.authToProceed,
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        log(e.toString());
        if (e.code == auth_error.notAvailable) {
          throw e.message!;
        }
        throw e.message!;
      }
    } else {
      throw 'Failed to authenticate';
    }
  }
}
