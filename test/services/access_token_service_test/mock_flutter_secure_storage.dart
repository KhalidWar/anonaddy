import 'dart:convert';

import 'package:anonaddy/shared_components/constants/data_storage_keys.dart';
import 'package:anonaddy/shared_components/constants/secure_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_data/account_test_data.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  @override
  Future<String?> read(
      {required String key,
      IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions,
      WindowsOptions? wOptions}) async {
    if (key == SecureStorageKeys.accessTokenKey) {
      return '';
    }

    if (key == DataStorageKeys.accountKey) {
      return jsonEncode(AccountTestData.validAccountJson);
    }

    return null;
  }

  @override
  Future<void> write(
      {required String key,
      required String? value,
      IOSOptions? iOptions,
      AndroidOptions? aOptions,
      LinuxOptions? lOptions,
      WebOptions? webOptions,
      MacOsOptions? mOptions,
      WindowsOptions? wOptions}) async {}
}
