import 'package:anonaddy/services/networking.dart';
import 'package:flutter/foundation.dart';

class AccountData with ChangeNotifier {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String accountDetailsURL = 'account-details';

  String id,
      username,
      subscription,
      lastUpdated,
      email,
      createdAt,
      emailDescription;
  double bandwidth = 0;
  double bandwidthLimit = 0;
  int usernameCount = 0;

  Future getAccountData() async {
    Networking accountDetails = Networking('$baseURL/$accountDetailsURL');
    var _accountData = await accountDetails.getData();

    id = _accountData['data']['id'];
    username = _accountData['data']['username'];
    bandwidth = _accountData['data']['bandwidth'] / 1024000;
    bandwidthLimit = _accountData['data']['bandwidth_limit'] / 1024000;
    usernameCount = _accountData['data']['username_count'];
    subscription = _accountData['data']['subscription'];
    lastUpdated = _accountData['data']['updated_at'];

    print('_accountData ACCESSED!!!');
    notifyListeners();
  }
}
