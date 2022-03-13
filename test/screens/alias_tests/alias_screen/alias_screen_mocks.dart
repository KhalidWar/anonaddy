import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/services/alias/alias_service.dart';
import 'package:anonaddy/state_management/alias_state/alias_state_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../test_data/test_alias_data.dart';

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
  Future<Alias> getSpecificAlias(String aliasID) async {
    if (aliasID == 'error') {
      throw DioError(
        type: DioErrorType.response,
        requestOptions: RequestOptions(path: 'error'),
      );
    }

    return Alias.fromJson(testAliasData['data']);
  }
}

class _MockAliasTabNotifier extends Mock implements AliasTabNotifier {}
