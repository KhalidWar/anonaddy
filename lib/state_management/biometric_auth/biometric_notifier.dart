import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final biometricNotifier = ChangeNotifierProvider<BiometricNotifier>((ref) {
  final biometricService = ref.read(biometricAuthService);
  final secureStorage = ref.read(flutterSecureStorage);
  final showToast = ref.read(nicheMethods).showToast;

  return BiometricNotifier(
    biometricService: biometricService,
    secureStorage: secureStorage,
    showToast: showToast,
  );
});

class BiometricNotifier extends ChangeNotifier {
  BiometricNotifier({
    required this.biometricService,
    required this.secureStorage,
    required this.showToast,
  }) : super() {
    isEnabled = false;
    biometricService.init();
    _loadBiometricState();
  }

  final BiometricAuthService biometricService;
  final FlutterSecureStorage secureStorage;
  final Function showToast;

  static const biometricAuthKey = 'biometricAuthKey';

  late bool isEnabled;

  Future<void> toggleBiometric(bool input) async {
    try {
      final isAuth = await biometricService.authenticate();
      if (isAuth) {
        isEnabled = input;
        await _saveBiometricState(input);
      } else {
        showToast('Failed to authenticate');
      }
      notifyListeners();
    } catch (error) {
      showToast(error.toString());
    }
  }

  Future<void> _loadBiometricState() async {
    final boolValue = await secureStorage.read(key: biometricAuthKey);
    if (boolValue == null) {
      isEnabled = false;
    } else {
      boolValue == 'true' ? isEnabled = true : isEnabled = false;
    }
    notifyListeners();
  }

  Future<void> _saveBiometricState(bool input) async {
    await secureStorage.write(key: biometricAuthKey, value: input.toString());
  }
}
