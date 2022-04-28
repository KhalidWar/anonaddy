import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/state_management/alias_state/alias_state_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/test_alias_data.dart';

final testAliasTabProvider =
    StateNotifierProvider<AliasTabNotifier, AliasTabState>((ref) {
  return AliasTabNotifier(
    aliasService: _MockAliasService(),
    offlineData: _MockOfflineData(),
    // state: AliasScreenState.initialState(),
  );
});

final testAliasScreenProvider =
    StateNotifierProvider.autoDispose<AliasScreenNotifier, AliasScreenState>(
        (ref) {
  return AliasScreenNotifier(
    aliasService: _MockAliasService(),
    aliasTabNotifier: _MockAliasTabNotifier(),
    // state: AliasScreenState.initialState(),
  );
});

class _MockAliasService extends Mock implements AliasService {
  @override
  Future<List<Alias>> getAliases(String? deleted) async {
    final alias = Alias.fromJson(testAliasData['data']);
    return [alias, alias, alias];
  }

  @override
  Future<Alias> getSpecificAlias(String aliasID) async {
    if (aliasID == 'error') {
      throw DioError(
        error: AppStrings.somethingWentWrong,
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: 'error'),
      );
    }

    return Alias.fromJson(testAliasData['data']);
  }
}

class _MockAliasTabNotifier extends Mock implements AliasTabNotifier {}

class _MockOfflineData extends Mock implements OfflineData {
  @override
  Future<String> readAliasOfflineData() async {
    return '';
  }

  @override
  Future<void> writeAliasOfflineData(String data) async {}
}
