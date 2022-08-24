import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/shared_components/constants/secure_storage_keys.dart';
import 'package:anonaddy/state_management/authorization/auth_notifier.dart';
import 'package:anonaddy/state_management/authorization/auth_state.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/state_management/domain_options/domain_options_state.dart';
import 'package:anonaddy/state_management/search/search_history/search_history_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';

/// Mocks a successful login [AuthorizationStatus.unknown]
final testFailedAuthStateNotifier =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    secureStorage: _MockSecureStorage(),
    biometricService: _MockBiometricService(),
    tokenService: _MockFailedAccessTokenService(),
    searchHistory: _MockSearchHistoryNotifier(),
  );
});

/// Mocks a successful login [AuthorizationStatus.authorized]
final testSuccessAuthStateNotifier =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    secureStorage: _MockSecureStorage(),
    biometricService: _MockBiometricService(),
    tokenService: _MockSuccessAccessTokenService(),
    searchHistory: _MockSearchHistoryNotifier(),
  );
});

final testDomainOptionsNotifier =
    StateNotifierProvider<DomainOptionsNotifier, DomainOptionsState>((ref) {
  return DomainOptionsNotifier(
    offlineData: _MockOfflineData(),
    domainOptionsService: _MockDomainOptionsService(),
  );
});

class _MockSecureStorage extends Mock implements FlutterSecureStorage {
  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return null;
  }
}

class _MockBiometricService extends Mock implements BiometricAuthService {
  @override
  Future<bool> _doesDeviceSupportBioAuth() async => false;
}

class _MockFailedAccessTokenService extends Mock implements AccessTokenService {
  @override
  Future<String> getAccessToken(
      {String key = SecureStorageKeys.accessTokenKey}) async {
    /// Mocks no accessToken is available
    return '';
  }

  @override
  Future<String> getInstanceURL() async {
    /// Mocks no instanceUrl is available
    return '';
  }
}

class _MockSuccessAccessTokenService extends Mock
    implements AccessTokenService {
  @override
  Future<String> getAccessToken(
      {String key = SecureStorageKeys.accessTokenKey}) async {
    /// Mocks accessToken is available
    return '123';
  }

  @override
  Future<String> getInstanceURL() async {
    /// Mocks instanceUrl is available
    return '123';
  }
}

class _MockSearchHistoryNotifier extends Mock implements SearchHistoryNotifier {
  @override
  Future<void> clearSearchHistory() async {}
}

class _MockOfflineData extends Mock implements OfflineData {
  @override
  Future<String> readDomainOptionsOfflineData() async => '';

  @override
  Future<void> writeDomainOptionsOfflineData(String data) async {}
}

class _MockDomainOptionsService extends Mock implements DomainOptionsService {
  @override
  Future<DomainOptions> getDomainOptions() async {
    return const DomainOptions(domains: []);
  }
}
