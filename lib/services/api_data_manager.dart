import 'dart:collection';

import 'package:anonaddy/models/alias_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/services/networking.dart';

class APIDataManager {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String accountDetailsURL = 'account-details';
  String activeAliasURL = 'active-aliases';
  String aliasesURL = 'aliases';

  List<AliasModel> _aliasList = [];
  UnmodifiableListView<AliasModel> get aliasList {
    return UnmodifiableListView(_aliasList);
  }

  Future<UserModel> fetchUserData() async {
    Networking networking = Networking('$baseURL/$accountDetailsURL');
    final response = await networking.getData();
    var data = UserModel.fromJson(response);
    return data;
  }

  Future<AliasModel> fetchAliasData() async {
    Networking aliasesDetails = Networking('$baseURL/$aliasesURL');
    final response = await aliasesDetails.getData();
    var data = AliasModel.fromJson(response);
    return data;
  }

  Future createNewAlias({String description}) async {
    Networking networking = Networking('$baseURL/$aliasesURL');
    var data = await networking.postData(description: description);
    return data;
  }

  Future activateAlias({String aliasID}) async {
    Networking networking = Networking('$baseURL/$activeAliasURL');
    var data = await networking.activateAlias(aliasID: aliasID);
    return data;
  }

  Future deactivateAlias({String aliasID}) async {
    Networking networking = Networking('$baseURL/$activeAliasURL/$aliasID');
    var data = await networking.deactivateAlias();
    return data;
  }

  Future editDescription({String newDescription}) async {
    Networking networking = Networking('$baseURL/$aliasesURL/$newDescription');
    var data = await networking.editDescription(newDescription: newDescription);
    return data;
  }

  Future deleteAlias({String aliasID}) async {
    Networking networking = Networking('$baseURL/$aliasesURL/$aliasID');
    var data = networking.deleteAlias();
    return data;
  }
}
