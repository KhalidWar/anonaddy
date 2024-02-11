import 'package:anonaddy/features/account/data/account_data_storage.dart';
import 'package:anonaddy/features/account/domain/account.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../services/access_token_service_test/mock_flutter_secure_storage.dart';

void main() {
  late FlutterSecureStorage secureStorage;
  late AccountDataStorage accountDataStorage;

  setUp(() {
    secureStorage = MockFlutterSecureStorage();
    accountDataStorage = AccountDataStorage(secureStorage: secureStorage);
  });

  group('AccountDataStorage testing', () {
    test('saveData method ', () async {
      expect(accountDataStorage.saveData({'key': 'value'}), completes);
    });

    test('loadData method ', () async {
      expect(accountDataStorage.loadData(), completes);

      final account = await accountDataStorage.loadData();
      expect(account, isA<Account>());
      expect(account, Account());
    });
  });
}
