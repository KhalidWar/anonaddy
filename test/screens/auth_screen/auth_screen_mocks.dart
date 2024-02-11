import 'package:anonaddy/features/auth/presentation/controller/auth_notifier.dart';
import 'package:anonaddy/features/auth/presentation/controller/auth_state.dart';
import 'package:anonaddy/features/domain_options/presentation/controller/domain_options_notifier.dart';
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
