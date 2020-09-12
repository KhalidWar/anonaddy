import 'package:anonaddy/services/networking.dart';
import 'package:flutter/cupertino.dart';
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
  int usernameCount;

  Future getAccountData() async {
    Networking accountDetails = Networking('$baseURL/$accountDetailsURL');
    var accountData = await accountDetails.getData();

    id = accountData['data']['id'];
    username = accountData['data']['username'];
    bandwidth = accountData['data']['bandwidth'] / 1024000;
    bandwidthLimit = accountData['data']['bandwidth_limit'] / 1024000;
    usernameCount = accountData['data']['username_count'];
    subscription = accountData['data']['subscription'];
    lastUpdated = accountData['data']['updated_at'];

    notifyListeners();
  }
}
