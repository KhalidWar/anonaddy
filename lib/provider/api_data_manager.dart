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

  List<AliasModel> _aliasList = [];
  UnmodifiableListView<AliasModel> get aliasList {
    return UnmodifiableListView(_aliasList);
  }

  Future<void> fetchData() async {
    Networking accountDetails = Networking('$baseURL/$accountDetailsURL');
    var _accountData = await accountDetails.getData();

    Networking aliasesDetails = Networking('$baseURL/$aliasesURL');
    var _aliasesData = await aliasesDetails.getData();

    var data = _accountData['data'];
    id = data['id'];
    username = data['username'];
    bandwidth = data['bandwidth'] / 1024000;
    bandwidthLimit = data['bandwidth_limit'] / 1024000;
    usernameCount = data['username_count'];
    subscription = data['subscription'];
    lastUpdated = data['updated_at'];
    aliasCount = data['active_shared_domain_alias_count'];
    aliasLimit = data['active_shared_domain_alias_limit'];

    _aliasList.clear();
    for (var data in _aliasesData['data']) {
      _aliasList.add(AliasModel(
        aliasID: data['id'],
        email: data['email'],
        emailDescription: data['description'] ?? 'None',
        createdAt: data['created_at'],
        isAliasActive: data['active'],
      ));
    }
    print('fetchData ACCESSED!!!');
    notifyListeners();
    return data;
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

  Future editDescription({String newDescription}) async {
    Networking networking = Networking('$baseURL/$aliasesURL/$newDescription');
    var data = await networking.editDescription(newDescription: newDescription);
    notifyListeners();
    return data;
  }

  Future deleteAlias({String aliasID}) async {
    Networking networking = Networking('$baseURL/$aliasesURL/$aliasID');
    var data = networking.deleteAlias();
    notifyListeners();
    return data;
  }
}
