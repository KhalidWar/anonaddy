import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/services/data_storage/offline_data_storage.dart';
import 'package:anonaddy/shared_components/constants/app_strings.dart';
import 'package:anonaddy/notifiers/alias_state/alias_tab_notifier.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/alias_test_data.dart';

class MockAliasService extends Mock implements AliasService {
  @override
  Future<List<Alias>> getAvailableAliases() async {
    final availableAlias = AliasTestData.validAliasWithRecipients();
    return [availableAlias, availableAlias, availableAlias, availableAlias];
  }

  @override
  Future<List<Alias>> getDeletedAliases() async {
    final availableAlias = AliasTestData.validAliasWithRecipients();
    final deletedAlias =
        availableAlias.copyWith(deletedAt: '2022-02-22 18:08:15');
    return [deletedAlias, deletedAlias, deletedAlias, deletedAlias];
  }

  @override
  Future<Alias> getSpecificAlias(String aliasID) async {
    if (aliasID.isEmpty) {
      throw DioError(
        error: AppStrings.somethingWentWrong,
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: 'error'),
      );
    }
    return AliasTestData.validAliasWithRecipients();
  }
}

class MockAliasTabNotifier extends Mock implements AliasTabNotifier {}

class MockOfflineData extends Mock implements OfflineData {
  @override
  Future<String> loadAliasTabState() async {
    return '';
  }

  @override
  Future<void> saveAliasTabState(String data) async {}
}
