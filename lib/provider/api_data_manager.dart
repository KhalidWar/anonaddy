import 'dart:collection';

import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/services/networking.dart';
import 'package:flutter/foundation.dart';

class APIDataManager with ChangeNotifier {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String accountDetailsURL = 'account-details';
  String activeAliasURL = 'active-aliases';
  String aliasesURL = 'aliases';

  String id, aliasID, username = 'username', subscription, lastUpdated;
  double bandwidth = 0, bandwidthLimit = 0;
  int usernameCount = 0, aliasCount = 0, aliasLimit = 0;

  bool isAliasActive = false;
  String email = 'Test';
  String createdAt = 'Test2';
  String emailDescription = 'Test3';

  List<AliasModel> _aliasList = [];
  UnmodifiableListView<AliasModel> get aliasList {
    return UnmodifiableListView(_aliasList);
  }

  Future<void> fetchData() async {
    Networking accountDetails = Networking('$baseURL/$accountDetailsURL');
    var _accountData = await accountDetails.getData();

    Networking aliasesDetails = Networking('$baseURL/$aliasesURL');
    var _aliasesData = await aliasesDetails.getData();

    id = _accountData['data']['id'];
    username = _accountData['data']['username'];
    bandwidth = _accountData['data']['bandwidth'] / 1024000;
    bandwidthLimit = _accountData['data']['bandwidth_limit'] / 1024000;
    usernameCount = _accountData['data']['username_count'];
    subscription = _accountData['data']['subscription'];
    lastUpdated = _accountData['data']['updated_at'];
    aliasCount = _accountData['data']['active_shared_domain_alias_count'];
    aliasLimit = _accountData['data']['active_shared_domain_alias_limit'];

    _aliasList.clear();
    for (int i = 0; i < _aliasesData['data'].length; i++) {
      email = _aliasesData['data'][i]['email'];
      createdAt = _aliasesData['data'][i]['created_at'];
      isAliasActive = _aliasesData['data'][i]['active'];
      emailDescription = _aliasesData['data'][i]['description'] ?? 'None';
      aliasID = _aliasesData['data'][i]['id'];

      _aliasList.add(AliasModel(
        aliasID: aliasID,
        email: email,
        emailDescription: emailDescription,
        createdAt: createdAt,
        isAliasActive: isAliasActive,
      ));
    }
    print('getAccountData ACCESSED!!!');
    notifyListeners();
  }

  Future createNewAlias({String description}) async {
    Networking networking = Networking('$baseURL/$aliasesURL');
    var data = await networking.postData(description: description);
    notifyListeners();
    return data;
  }

  Future activateAlias({String aliasID}) async {
    Networking networking = Networking('$baseURL/$activeAliasURL');
    var data = await networking.activateAlias(aliasID: aliasID);
    notifyListeners();
    return data;
  }

  Future deactivateAlias({String aliasID}) async {
    Networking networking = Networking('$baseURL/$activeAliasURL/$aliasID');
    var data = await networking.deactivateAlias();
    notifyListeners();
    return data;
  }
}
