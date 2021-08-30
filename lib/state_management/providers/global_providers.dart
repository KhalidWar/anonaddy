import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/models/account/account_model.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/models/app_version/app_version_model.dart';
import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/models/username/username_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';

import '../lifecycle/lifecycle_state_manager.dart';
import 'class_providers.dart';

/// Stream Providers
final accountStreamProvider =
    StreamProvider.autoDispose<AccountModel>((ref) async* {
  final offlineData = ref.read(offlineDataProvider);
  final lifecycleStatus = ref.watch(lifecycleStateProvider);

  final securedData = await offlineData.readAccountOfflineData();
  if (securedData.isNotEmpty) {
    yield AccountModel.fromJson(jsonDecode(securedData));
  }

  while (lifecycleStatus == LifecycleStatus.foreground) {
    yield* Stream.fromFuture(ref.read(userService).getAccountData(offlineData));
    await Future.delayed(Duration(seconds: 5));
  }
});

final aliasDataStream = StreamProvider.autoDispose<AliasModel>((ref) async* {
  final offlineData = ref.read(offlineDataProvider);
  final lifecycleStatus = ref.watch(lifecycleStateProvider);

  final securedData = await offlineData.readAliasOfflineData();
  if (securedData.isNotEmpty) {
    yield AliasModel.fromJson(jsonDecode(securedData));
  }

  while (lifecycleStatus == LifecycleStatus.foreground) {
    yield* Stream.fromFuture(
        ref.read(aliasService).getAllAliasesData(offlineData));
    await Future.delayed(Duration(seconds: 1));
  }
});

final recipientsProvider = StreamProvider<RecipientModel>((ref) async* {
  final offlineData = ref.read(offlineDataProvider);
  final lifecycleStatus = ref.watch(lifecycleStateProvider);

  final securedData = await offlineData.readRecipientsOfflineData();
  if (securedData.isNotEmpty) {
    yield RecipientModel.fromJson(jsonDecode(securedData));
  }

  while (lifecycleStatus == LifecycleStatus.foreground) {
    yield* Stream.fromFuture(
        ref.read(recipientService).getAllRecipient(offlineData));
    await Future.delayed(Duration(seconds: 5));
  }
});

/// Future Providers
final usernamesProvider = FutureProvider.autoDispose<UsernameModel>((ref) {
  final offlineData = ref.read(offlineDataProvider);
  return ref.read(usernameService).getUsernameData(offlineData);
});

final domainsProvider = FutureProvider.autoDispose<DomainModel>((ref) async {
  final offlineData = ref.read(offlineDataProvider);
  return await ref.read(domainService).getAllDomains(offlineData);
});

final domainOptionsProvider = FutureProvider<DomainOptions>((ref) {
  final offlineData = ref.read(offlineDataProvider);
  return ref.read(domainOptionsService).getDomainOptions(offlineData);
});

final accessTokenProvider = FutureProvider<String>(
    (ref) async => await ref.watch(accessTokenService).getAccessToken());

final packageInfoProvider =
    FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

final appVersionProvider = FutureProvider.autoDispose<AppVersion>((ref) async {
  return await ref.read(appVersionService).getAppVersionData();
});

final failedDeliveriesProvider =
    FutureProvider.autoDispose<FailedDeliveriesModel>((ref) async {
  return await ref.read(failedDeliveriesService).getFailedDeliveries();
});
