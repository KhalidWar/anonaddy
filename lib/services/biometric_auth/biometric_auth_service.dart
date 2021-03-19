import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final _localAuth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> authenticate(bool canCheckBiometric) async {
    if (canCheckBiometric == true) {
      try {
        return await _localAuth.authenticateWithBiometrics(
          localizedReason: 'Please authenticate!',
          useErrorDialogs: true,
          stickyAuth: true,
        );
      } on PlatformException catch (e) {
        print(e);
        throw e;
        // if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
        // }
      }
    }
    throw Exception('No biometric available');
  }

  Future<List<BiometricType>> getAvailableBiometrics(
      bool canCheckBiometric) async {
    List<BiometricType> _availableBiometrics = [];

    final canCheck = await canCheckBiometrics();

    if (canCheck == true) {
      try {
        await _localAuth.getAvailableBiometrics().then((value) {
          if (Platform.isIOS) {
            if (_availableBiometrics.contains(BiometricType.face)) {
              // Face ID.
            } else if (_availableBiometrics
                .contains(BiometricType.fingerprint)) {
              // Touch ID.
            }
          } else if (Platform.isAndroid) {
            return _availableBiometrics;
            // authenticate();
          }
        });
      } on PlatformException catch (e) {
        print(e);
        throw e;
        // if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
        // }
      }
    }
  }

  Future<void> clearAppData(BuildContext context) async {
    //todo reset/clear app data
    final secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
  }
}
