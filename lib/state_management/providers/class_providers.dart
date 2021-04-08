import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/connectivity/connectivity_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/data_storage/search_history_storage.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/services/domains/domains_service.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/services/secure_app_service/secure_app_service.dart';
import 'package:anonaddy/services/theme/theme_service.dart';
import 'package:anonaddy/services/user/user_service.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../alias_state_manager.dart';
import '../lifecycle_state_manager.dart';
import '../login_state_manager.dart';
import '../recipient_state_manager.dart';
import '../settings_state_manager.dart';
import '../username_state_manager.dart';

/// Class Providers
final usernameServiceProvider = Provider((ref) => UsernameService());
final userServiceProvider = Provider((ref) => UserService());
final aliasServiceProvider = Provider((ref) => AliasService());
final domainOptionsServiceProvider = Provider((ref) => DomainOptionsService());
final accessTokenServiceProvider = Provider((ref) => AccessTokenService());
final recipientServiceProvider = Provider((ref) => RecipientService());
final domainsServiceProvider = Provider((ref) => DomainsService());
final biometricAuthServiceProvider = Provider((ref) => BiometricAuthService());
final connectivityServiceProvider = Provider((ref) => ConnectivityService());
final offlineDataProvider = Provider((ref) => OfflineData());

/// Notifier Providers
final aliasStateManagerProvider =
    ChangeNotifierProvider((ref) => AliasStateManager());

final searchHistoryProvider =
    ChangeNotifierProvider((ref) => SearchHistoryStorage());

final usernameStateManagerProvider =
    ChangeNotifierProvider((ref) => UsernameStateManager());

final loginStateManagerProvider =
    ChangeNotifierProvider((ref) => LoginStateManager());

final recipientStateManagerProvider =
    ChangeNotifierProvider((ref) => RecipientStateManager());

final secureAppProvider =
    ChangeNotifierProvider<SecureAppService>((ref) => SecureAppService());

final lifecycleStateManagerProvider =
    ChangeNotifierProvider((ref) => LifecycleStateManager());

final themeServiceProvider =
    ChangeNotifierProvider<ThemeService>((ref) => ThemeService());

final settingsStateManagerProvider =
    ChangeNotifierProvider((ref) => SettingsStateManager());
