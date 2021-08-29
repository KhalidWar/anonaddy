import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/app_version/app_version_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/changelog_service/changelog_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/alias_state/fab_visibility_state.dart';
import 'package:anonaddy/state_management/connectivity/connectivity_state.dart';
import 'package:anonaddy/state_management/domain_state_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../alias_state_manager.dart';
import '../lifecycle/lifecycle_state_manager.dart';
import '../login_state_manager.dart';
import '../recipient_state_manager.dart';
import '../settings_state_manager.dart';
import '../username_state_manager.dart';

/// Class Providers
final usernameServiceProvider = Provider((ref) => UsernameService());
final userServiceProvider = Provider((ref) => AccountService());
final aliasServiceProvider = Provider((ref) => AliasService());
final domainOptionsServiceProvider = Provider((ref) => DomainOptionsService());
final accessTokenServiceProvider = Provider((ref) => AccessTokenService());
final recipientServiceProvider = Provider((ref) => RecipientService());
final domainServiceProvider = Provider((ref) => DomainsService());
final biometricAuthServiceProvider = Provider((ref) => BiometricAuthService());
final connectivityState = Provider((ref) => ConnectivityState(Connectivity()));
final offlineDataProvider = Provider((ref) => OfflineData());
final changelogServiceProvider = Provider((ref) => ChangelogService());
final appVersionServiceProvider = Provider((ref) => AppVersionService());
final fabVisibilityStateProvider = Provider(
    (ref) => FabVisibilityState(ScrollController(), ScrollController()));
final lifecycleState = Provider((ref) => LifecycleState());

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
