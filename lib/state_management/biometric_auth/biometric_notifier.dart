import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final biometricNotifier = ChangeNotifierProvider<BiometricNotifier>((ref) {
  return BiometricNotifier(
    biometricService: ref.read(biometricAuthServiceProvider),
    secureStorage: ref.read(flutterSecureStorage),
  );
});

class BiometricNotifier extends ChangeNotifier {
  BiometricNotifier({
    required this.biometricService,
    required this.secureStorage,
  }) : super() {
    isEnabled = false;
    _loadBiometricState();
  }

  final BiometricAuthService biometricService;
  final FlutterSecureStorage secureStorage;

  static const biometricAuthKey = 'biometricAuthKey';

  late bool isEnabled;

  Future<void> toggleBiometric(bool input) async {
    try {
      final didAuth = await biometricService.authenticate();
      if (didAuth) {
        isEnabled = input;
        await _saveBiometricState(input);
      } else {
        NicheMethod.showToast('Failed to authenticate');
      }
      notifyListeners();
    } catch (error) {
      NicheMethod.showToast(error.toString());
    }
  }

  Future<void> _loadBiometricState() async {
    try {
      final boolValue = await secureStorage.read(key: biometricAuthKey);
      if (boolValue == null) {
        isEnabled = false;
      } else {
        boolValue == 'true' ? isEnabled = true : isEnabled = false;
      }
      notifyListeners();
    } catch (error) {
      NicheMethod.showToast('Failed to load biometric authentication state');
      return;
    }
  }

  Future<void> _saveBiometricState(bool input) async {
    try {
      await secureStorage.write(key: biometricAuthKey, value: input.toString());
    } catch (error) {
      NicheMethod.showToast('Failed to save biometric authentication state');

      return;
    }
  }
}
