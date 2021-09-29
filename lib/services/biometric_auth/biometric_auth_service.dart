import 'dart:developer';

import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  BiometricAuthService(this.localAuth);
  final LocalAuthentication localAuth;

  late bool canCheckBio;

  Future<void> init() async {
    try {
      canCheckBio = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      throw e.message ?? 'Failed to authenticate';
    }
  }

  Future<bool> authenticate() async {
    if (canCheckBio) {
      try {
        return await localAuth.authenticate(
          localizedReason: kAuthToProceed,
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
