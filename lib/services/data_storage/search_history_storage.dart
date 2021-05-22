import 'dart:convert';

import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/shared_components/constants/hive_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class SearchHistoryStorage {
  final _secureStorage = const FlutterSecureStorage();

  static Box<AliasDataModel> getAliasBoxes() {
    return Hive.box<AliasDataModel>(kSearchHistoryBox);
  }

  Future<void> openSearchHiveBox() async {
    final secureKey = await _secureStorage.read(key: kHiveSecureKey);
    final encryptionKey = base64Url.decode(secureKey);
    await Hive.openBox<AliasDataModel>(
      kSearchHistoryBox,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }
}
