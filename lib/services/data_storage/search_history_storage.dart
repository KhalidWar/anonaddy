import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchHistoryStorage extends ChangeNotifier {
  final _secureStorage = FlutterSecureStorage();
  final String _key = 'searchHistoryKey';
  final List<AliasDataModel> _aliasList = [];

  Future<void> saveData(AliasDataModel alias) async {
    _aliasList.add(alias);
    final encodedAlias = AliasDataModel.encode(_aliasList);
    await _secureStorage.write(key: _key, value: encodedAlias);
  }

  Future<List<AliasDataModel>> loadData() async {
    final encodedAlias = await _secureStorage.read(key: _key);
    final decodedData = AliasDataModel.decode(encodedAlias ?? "[]");
    return decodedData;
  }

  Future<void> clearSearchHistory(BuildContext context) async {
    context.read(aliasStateManagerProvider).recentSearchesList.clear();
    await _secureStorage.delete(key: _key);
    notifyListeners();
  }
}
