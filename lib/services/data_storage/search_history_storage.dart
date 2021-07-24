import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/shared_components/constants/hive_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class SearchHistoryStorage {
  final _secureStorage = const FlutterSecureStorage();

  static Box<Alias> getAliasBoxes() {
    return Hive.box<Alias>(kSearchHistoryBox);
  }

  Future<void> openSearchHiveBox() async {
    final secureKey = await _secureStorage.read(key: kHiveSecureKey);
    final encryptionKey = base64Url.decode(secureKey!);
    await Hive.openBox<Alias>(
      kSearchHistoryBox,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }
}
