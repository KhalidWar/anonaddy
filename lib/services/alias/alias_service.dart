import 'dart:async';
import 'dart:convert';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

import '../access_token/access_token_service.dart';

class AliasService {
  const AliasService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<List<Alias>> getAllAliasesData(String? deleted) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL',
            {'deleted': deleted}),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getAllAliasesData ${response.statusCode}');
        final decodedData = jsonDecode(response.body)['data'];
        return (decodedData as List).map((alias) {
          return Alias.fromJson(alias);
        }).toList();
      } else {
        print('getAllAliasesData ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Alias> getSpecificAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID',
            {'deleted': 'with'}),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('getSpecificAlias ${response.statusCode}');
        final alias = jsonDecode(response.body)['data'];
        return Alias.fromJson(alias);
      } else {
        print('getSpecificAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Alias> createNewAlias(
      {required String desc,
      localPart,
      domain,
      format,
      required List<String> recipients}) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({
          "domain": domain,
          "format": format,
          "description": desc,
          "recipient_ids": recipients,
          if (format == 'custom') "local_part": localPart,
        }),
      );

      if (response.statusCode == 201) {
        print("createNewAlias ${response.statusCode}");
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        print("createNewAlias ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Alias> activateAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kActiveAliasURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"id": "$aliasID"}),
      );

      if (response.statusCode == 200) {
        print('Network activateAlias ${response.statusCode}');
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        print('Network activateAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deactivateAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kActiveAliasURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('Network deactivateAlias ${response.statusCode}');
        return 204;
      } else {
        print('Network deactivateAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Alias> editAliasDescription(String aliasID, String newDesc) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"description": "$newDesc"}),
      );

      if (response.statusCode == 200) {
        print('Network editDescription ${response.statusCode}');
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        print('Network editDescription ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future deleteAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('Network deleteAlias ${response.statusCode}');
        return 204;
      } else {
        print('Network deleteAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Alias> restoreAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(
            instanceURL, '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/restore'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        print('Network restoreAlias ${response.statusCode}');
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        print('Network restoreAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Alias> updateAliasDefaultRecipient(
      String aliasID, List<String> recipients) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kAliasURL-$kRecipientsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "alias_id": aliasID,
          "recipient_ids": recipients,
        }),
      );

      if (response.statusCode == 200) {
        print('editAliasRecipient ${response.statusCode}');
        return Alias.fromJson(jsonDecode(response.body)['data']);
      } else {
        print('editAliasRecipient ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future forgetAlias(String aliasID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL,
            '$kUnEncodedBaseURL/$kAliasesURL/$aliasID/$kForgetURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        print('forgetAlias ${response.statusCode}');
        return 204;
      } else {
        print('forgetAlias ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }
}
