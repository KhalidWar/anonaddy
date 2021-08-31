import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/app_version/app_version_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/changelog_service/changelog_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/services/failed_deliveries/failed_deliveries_service.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/state_management/connectivity/connectivity_state.dart';
import 'package:anonaddy/state_management/domain_state_manager.dart';
import 'package:anonaddy/state_management/lifecycle/lifecycle_state_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../alias_state_manager.dart';
import '../login_state_manager.dart';
import '../recipient_state_manager.dart';
import '../settings_state_manager.dart';
import '../username_state_manager.dart';

/// Class Providers
final flutterSecureStorage = Provider((ref) => FlutterSecureStorage());

final biometricAuthServiceProvider =
    Provider((ref) => BiometricAuthService(LocalAuthentication()));

final offlineDataProvider = Provider<OfflineData>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return OfflineData(secureStorage);
});

final accessTokenService = Provider<AccessTokenService>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return AccessTokenService(secureStorage);
});

final changelogService = Provider<ChangelogService>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return ChangelogService(secureStorage);
});

final usernameService = Provider<UsernameService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return UsernameService(accessToken);
});

final userService = Provider<AccountService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return AccountService(accessToken);
});

final aliasService = Provider<AliasService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return AliasService(accessToken);
});

final domainOptionsService = Provider<DomainOptionsService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return DomainOptionsService(accessToken);
});

final recipientService = Provider<RecipientService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return RecipientService(accessToken);
});

final domainService = Provider<DomainsService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return DomainsService(accessToken);
});

final appVersionService = Provider<AppVersionService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return AppVersionService(accessToken);
});

final failedDeliveriesService = Provider<FailedDeliveriesService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return FailedDeliveriesService(accessToken);
});

/// Notifier Providers
final aliasStateManagerProvider =
    ChangeNotifierProvider((ref) => AliasStateManager());

final usernameStateManagerProvider =
    ChangeNotifierProvider((ref) => UsernameStateManager());

final loginStateManagerProvider =
    ChangeNotifierProvider((ref) => LoginStateManager());

final recipientStateManagerProvider =
    ChangeNotifierProvider((ref) => RecipientStateManager());

final settingsStateManagerProvider =
    ChangeNotifierProvider((ref) => SettingsStateManager());

final domainStateManagerProvider =
    ChangeNotifierProvider((ref) => DomainStateManager());

/// State Providers
final connectivityState = Provider((ref) => ConnectivityState(Connectivity()));
final lifecycleState = Provider((ref) => LifecycleState());
final fabVisibilityStateProvider = Provider(
    (ref) => FabVisibilityState(ScrollController(), ScrollController()));
