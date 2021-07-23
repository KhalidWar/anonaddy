import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final _localAuth = LocalAuthentication();

  Future<bool> canEnableBiometric() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      throw e.message!;
    }
  }

  Future<bool> authenticate(bool canCheckBio) async {
    if (canCheckBio) {
      try {
        return await _localAuth.authenticate(
          localizedReason: kAuthToProceed,
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        print(e);
        if (e.code == auth_error.notAvailable) {
          throw e.message!;
        }
        throw e.message!;
      }
    }
    return false;
  }
}
