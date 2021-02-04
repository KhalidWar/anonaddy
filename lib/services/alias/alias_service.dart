import 'dart:convert';

import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/models/alias/alias_model.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../access_token/access_token_service.dart';

class AliasService {
  final _headers = <String, String>{
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  Future<AliasModel> getAllAliasesData() async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.get(
          Uri.encodeFull('$kBaseURL/$kAliasesURL?deleted=with'),
          headers: _headers);

      if (response.statusCode == 200) {
        print('getAllAliasesData ${response.statusCode}');
        return AliasModel.fromJson(jsonDecode(response.body));
      } else {
        print('getAllAliasesData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future createNewAlias(
      String desc, String domain, String format, String localPart) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kAliasesURL'),
        headers: _headers,
        body: json.encode({
          "domain": "$domain",
          "format": "$format",
          "description": "$desc",
          if (format == 'custom') "local_part": "$localPart"
        }),
      );

      if (response.statusCode == 201) {
        print("createNewAlias ${response.statusCode}");
        return 201;
      } else {
        print("createNewAlias ${response.statusCode}");
        return APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future activateAlias(String aliasID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.post(
        Uri.encodeFull('$kBaseURL/$kActiveAliasURL'),
        headers: _headers,
        body: json.encode({"id": "$aliasID"}),
      );

      if (response.statusCode == 200) {
        print('Network activateAlias ${response.statusCode}');
        return jsonDecode(response.body);
      } else {
        print('Network activateAlias ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future deactivateAlias(String aliasID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kActiveAliasURL/$aliasID'),
          headers: _headers);

      if (response.statusCode == 204) {
        print('Network deactivateAlias ${response.statusCode}');
        return response.body;
      } else {
        print('Network deactivateAlias ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<AliasDataModel> editAliasDescription(
      String aliasID, String newDesc) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.patch(
          Uri.encodeFull('$kBaseURL/$kAliasesURL/$aliasID'),
          headers: _headers,
          body: jsonEncode({"description": "$newDesc"}));

      if (response.statusCode == 200) {
        print('Network editDescription ${response.statusCode}');
        return AliasDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print('Network editDescription ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deleteAlias(String aliasID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.delete(
          Uri.encodeFull('$kBaseURL/$kAliasesURL/$aliasID'),
          headers: _headers);

      if (response.statusCode == 204) {
        print('Network deleteAlias ${response.statusCode}');
        return 204;
      } else {
        print('Network deleteAlias ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future restoreAlias(String aliasID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.patch(
          Uri.encodeFull('$kBaseURL/$kAliasesURL/$aliasID/restore'),
          headers: _headers);

      if (response.statusCode == 200) {
        print('Network restoreAlias ${response.statusCode}');
        return 200;
      } else {
        print('Network restoreAlias ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  //todo unused method
  Future<AliasDataModel> getSpecificAliasData(String aliasID) async {
    try {
      final accessToken = await AccessTokenService().getAccessToken();
      _headers["Authorization"] = "Bearer $accessToken";

      final response = await http.get(
          Uri.encodeFull('$kBaseURL/$kAliasesURL/$aliasID'),
          headers: _headers);

      if (response.statusCode == 200) {
        print(' getSpecificAliasData ${response.statusCode}');
        return AliasDataModel.fromJsonData(jsonDecode(response.body));
      } else {
        print(' getSpecificAliasData ${response.statusCode}');
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
