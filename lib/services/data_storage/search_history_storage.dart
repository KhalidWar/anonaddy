import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchHistoryStorage {
  final _secureStorage = FlutterSecureStorage();
  final List<AliasDataModel> _aliasList = [];

  final String key = 'key';

  Future<void> saveData(AliasDataModel alias) async {
    _aliasList.add(alias);
    final encodedAlias = AliasDataModel.encode(_aliasList);
    await _secureStorage.write(key: key, value: encodedAlias);
  }

  Future<List<AliasDataModel>> loadData() async {
    final encodedAlias = await _secureStorage.read(key: key);
    final decodedData = AliasDataModel.decode(encodedAlias);
    return decodedData;
  }
}
