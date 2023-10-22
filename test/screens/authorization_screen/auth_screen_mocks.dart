import 'package:anonaddy/notifiers/authorization/auth_notifier.dart';
import 'package:anonaddy/notifiers/authorization/auth_state.dart';
import 'package:anonaddy/notifiers/domain_options/domain_options_notifier.dart';
import 'package:anonaddy/notifiers/domain_options/domain_options_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../mocks.dart';

/// Mocks a successful login [AuthorizationStatus.unknown]
final testAuthStateNotifier =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    secureStorage: MockFlutterSecureStorage(),
    biometricService: MockBiometricService(),
    tokenService: MockAccessTokenService(),
    searchHistory: MockSearchHistoryNotifier(),
  );
});

final testDomainOptionsNotifier =
    StateNotifierProvider<DomainOptionsNotifier, DomainOptionsState>((ref) {
  return DomainOptionsNotifier(
    domainOptionsService: MockDomainOptionsService(),
  );
});
