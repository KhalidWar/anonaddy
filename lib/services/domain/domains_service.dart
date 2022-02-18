import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class DomainsService {
  const DomainsService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<DomainModel> getAllDomains() async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kDomainsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        log('getAllDomains ${response.statusCode}');
        return DomainModel.fromJson(jsonDecode(response.body));
      } else {
        log('getAllDomains ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> getSpecificDomain(String domainId) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kDomainsURL/$domainId'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        log('getSpecificDomain ${response.statusCode}');
        return Domain.fromJson(jsonDecode(response.body)['data']);
      } else {
        log('getSpecificDomain ${response.statusCode}');
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> createNewDomain(String domain) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kDomainsURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"domain": domain}),
      );

      if (response.statusCode == 201) {
        log("createNewDomain ${response.statusCode}");
        return Domain.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("createNewDomain ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> editDomainDescription(
      String domainID, String description) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kDomainsURL/$domainID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"description": description}),
      );

      if (response.statusCode == 200) {
        log("editDomainDescription ${response.statusCode}");
        return Domain.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("editDomainDescription ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteDomain(String domainID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kDomainsURL/$domainID'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        log("deleteDomain ${response.statusCode}");
        return 204;
      } else {
        log("deleteDomain ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> updateDomainDefaultRecipient(
      String domainID, String recipientID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.patch(
        Uri.https(instanceURL,
            '$kUnEncodedBaseURL/$kDomainsURL/$domainID/$kDefaultRecipientURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"default_recipient": recipientID}),
      );

      if (response.statusCode == 200) {
        log("updateDomainDefaultRecipient ${response.statusCode}");
        return Domain.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("updateDomainDefaultRecipient ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> activateDomain(String domainID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kActiveDomainURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"id": domainID}),
      );

      if (response.statusCode == 200) {
        log("activateDomain ${response.statusCode}");
        return Domain.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("activateDomain ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deactivateDomain(String domainID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
          Uri.https(
              instanceURL, '$kUnEncodedBaseURL/$kActiveDomainURL/$domainID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        log("deactivateDomain ${response.statusCode}");
        return 204;
      } else {
        log("deactivateDomain ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> activateCatchAll(String domainID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.post(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kCatchAllDomainURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: json.encode({"id": domainID}),
      );

      if (response.statusCode == 200) {
        log("activateCatchAll ${response.statusCode}");
        return Domain.fromJson(jsonDecode(response.body)['data']);
      } else {
        log("activateCatchAll ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deactivateCatchAll(String domainID) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
          Uri.https(
              instanceURL, '$kUnEncodedBaseURL/$kCatchAllDomainURL/$domainID'),
          headers: {
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken",
          });

      if (response.statusCode == 204) {
        log("deactivateCatchAll ${response.statusCode}");
        return 204;
      } else {
        log("deactivateCatchAll ${response.statusCode}");
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
