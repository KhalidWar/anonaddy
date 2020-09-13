import 'package:anonaddy/models/aliases.dart';
import 'package:anonaddy/services/networking.dart';
import 'package:flutter/foundation.dart';

class AliasesData with ChangeNotifier {
  String baseURL = 'https://app.anonaddy.com/api/v1';
  String aliases = 'aliases';
  bool isAliasActive = false;
  String email = 'Test';
  String createdAt = 'Test2';
  String emailDescription = 'Test3';

  List<Aliases> aliasList = [];

  Future getAliasesDetails() async {
    Networking aliasesDetails = Networking('$baseURL/$aliases');
    var _aliasesData = await aliasesDetails.getData();

    for (var i = 0; i < _aliasesData['data'].length; i++) {
      email = _aliasesData['data'][i]['email'];
      createdAt = _aliasesData['data'][i]['created_at'];
      isAliasActive = _aliasesData['data'][i]['active'];
      emailDescription = _aliasesData['data'][i]['description'] ?? 'None';

      aliasList.add(Aliases(
        email: email,
        emailDescription: emailDescription,
        createdAt: createdAt,
        isAliasActive: isAliasActive,
      ));
      print('_aliasesData ACCESSED!!!');
    }
    notifyListeners();
  }

  Future createNewAlias({String description}) async {
    Networking networking = Networking('$baseURL/$aliases');
    var data = await networking.postData(description: description);
    notifyListeners();
    return data;
  }

  // Future deactivateAlias({String id}) async {
  // Networking networking = Networking('$baseURL/$activeAliasURL/$id');
  // var data = await networking.toggleAliasActive();
  // return data;
  // }
}
