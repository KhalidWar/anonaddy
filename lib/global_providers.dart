import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
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
import 'package:anonaddy/services/failed_deliveries/failed_deliveries_service.dart';
import 'package:anonaddy/services/recipient/recipient_service.dart';
import 'package:anonaddy/services/rules/rules_service.dart';
import 'package:anonaddy/services/search/search_service.dart';
import 'package:anonaddy/services/username/username_service.dart';
import 'package:anonaddy/state_management/settings/settings_data_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
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
  final secureStorage = ref.read(flutterSecureStorage);
  return AccessTokenService(
    secureStorage: secureStorage,
    httpClient: IOClient(),
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
  final accessToken = ref.read(accessTokenService);
  return AliasService(accessToken, ref.read(dioProvider));
});

final searchService = Provider<SearchService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return SearchService(accessToken);
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

final rulesService = Provider<RulesService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return RulesService(accessToken);
});

final appVersionService = Provider<AppVersionService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return AppVersionService(accessToken);
});

final failedDeliveriesService = Provider<FailedDeliveriesService>((ref) {
  final accessToken = ref.read(accessTokenService);
  return FailedDeliveriesService(accessToken);
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

final failedDeliveriesProvider =
    FutureProvider.autoDispose<FailedDeliveriesModel>((ref) async {
  return await ref.read(failedDeliveriesService).getFailedDeliveries();
});
