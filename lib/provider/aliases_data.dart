import 'package:anonaddy/services/networking.dart';
import 'package:flutter/foundation.dart';

class AliasesData with ChangeNotifier {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String aliases = 'aliases';

  Future getAliasesDetails() async {
    Networking aliasesDetails = Networking('$baseURL/$aliases');
    var aliasesData = await aliasesDetails.getData();

    notifyListeners();
  }

  Future createNewAlias({String description}) async {
    Networking networking = Networking('$baseURL/$aliases');
    var data = await networking.postData(description: description);
    return data;
  }

  Future deactivateAlias({String id}) async {
    // Networking networking = Networking('$baseURL/$activeAliasURL/$id');
    // var data = await networking.toggleAliasActive();
    // return data;
  }
}
