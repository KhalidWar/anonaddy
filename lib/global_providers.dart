import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/account/account_service.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/app_version/app_version_service.dart';
import 'package:anonaddy/services/biometric_auth/biometric_auth_service.dart';
import 'package:anonaddy/services/changelog_service/changelog_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/services/domain/domains_service.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:anonaddy/services/failed_delivery/failed_delivery_service.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/services/rules/rules_service.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/settings/settings_data_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Class Providers
final flutterSecureStorage = Provider((ref) => const FlutterSecureStorage());

final biometricAuthService =
    Provider((ref) => BiometricAuthService(LocalAuthentication()));

final offlineDataProvider = Provider<OfflineData>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return OfflineData(secureStorage);
});

final dioProvider = Provider<Dio>((ref) {
  final interceptors = ref.read(dioInterceptorProvider);
  final dio = Dio();
  dio.interceptors.add(interceptors);
  return dio;
});

final dioInterceptorProvider = Provider((ref) {
  return DioInterceptors(ref.read(accessTokenService));
});

final accessTokenService = Provider<AccessTokenService>((ref) {
  return AccessTokenService(
    secureStorage: ref.read(flutterSecureStorage),
    dio: Dio(),
  );
});

final changelogService = Provider<ChangelogService>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return ChangelogService(secureStorage);
});

final usernameService = Provider<UsernameService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return UsernameService(accessToken);
});

final accountService = Provider<AccountService>((ref) {
  final dio = ref.read(dioProvider);
  return AccountService(dio);
});

final aliasService = Provider<AliasService>((ref) {
  return AliasService(ref.read(dioProvider));
});

final searchService = Provider<SearchService>((ref) {
  return SearchService(ref.read(dioProvider));
});

final domainOptionsService = Provider<DomainOptionsService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return DomainOptionsService(ref.read(dioProvider));
});

final recipientService = Provider<RecipientService>((ref) {
  return RecipientService(dio: ref.read(dioProvider));
});

final domainService = Provider<DomainsService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return DomainsService(accessToken);
});

final rulesService = Provider<RulesService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return RulesService(ref.read(dioProvider));
});

final appVersionService = Provider<AppVersionService>((ref) {
  return AppVersionService(ref.read(dioProvider));
});

final failedDeliveryService = Provider<FailedDeliveryService>((ref) {
  return FailedDeliveryService(ref.read(dioProvider));
});

final settingsDataStorage = Provider<SettingsDataStorage>((ref) {
  final secureStorage = ref.read(flutterSecureStorage);
  return SettingsDataStorage(secureStorage);
});

/// Future Providers
final packageInfoProvider =
    FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

final appVersionProvider = FutureProvider.autoDispose<AppVersion>((ref) async {
  return await ref.read(appVersionService).getAppVersionData();
});
