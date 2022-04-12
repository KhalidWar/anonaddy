import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class DomainsService {
  const DomainsService(this.accessTokenService, this.dio);
  final AccessTokenService accessTokenService;
  final Dio dio;

  Future<DomainModel> getDomains() async {
    try {
      const path = '$kUnEncodedBaseURL/$kDomainsURL';
      final response = await dio.get(path);
      log('getDomains: ' + response.statusCode.toString());
      return DomainModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> getSpecificDomain(String domainId) async {
    try {
      final path = '$kUnEncodedBaseURL/$kDomainsURL/$domainId';
      final response = await dio.get(path);
      log('getSpecificDomain: ' + response.statusCode.toString());
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> addNewDomain(String domain) async {
    try {
      const path = '$kUnEncodedBaseURL/$kDomainsURL';
      final data = json.encode({"domain": domain});
      final response = await dio.post(path, data: data);
      log('addNewDomain: ' + response.statusCode.toString());
      final newDomain = response.data['data'];
      return Domain.fromJson(newDomain);
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> updateDomainDescription(
      String domainID, String description) async {
    try {
      final path = '$kUnEncodedBaseURL/$kDomainsURL/$domainID';
      final data = jsonEncode({"description": description});
      final response = await dio.patch(path, data: data);
      log('updateDomainDescription: ' + response.statusCode.toString());
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDomain(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kDomainsURL/$domainID';
      final response = await dio.delete(path);
      log('deleteDomain: ' + response.statusCode.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> updateDomainDefaultRecipient(
      String domainID, String recipientID) async {
    try {
      final path =
          '$kUnEncodedBaseURL/$kDomainsURL/$domainID/$kDefaultRecipientURL';
      final data = jsonEncode({"default_recipient": recipientID});
      final response = await dio.patch(path, data: data);
      log('updateDomainDefaultRecipient: ' + response.statusCode.toString());
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> activateDomain(String domainID) async {
    try {
      const path = '$kUnEncodedBaseURL/$kActiveDomainURL';
      final data = json.encode({"id": domainID});
      final response = await dio.post(path, data: data);
      log('activateDomain: ' + response.statusCode.toString());
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateDomain(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kActiveDomainURL/$domainID';
      final response = await dio.delete(path);
      log('deactivateDomain: ' + response.statusCode.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> activateCatchAll(String domainID) async {
    try {
      const path = '$kUnEncodedBaseURL/$kCatchAllDomainURL';
      final data = json.encode({"id": domainID});
      final response = await dio.post(path, data: data);
      log('activateCatchAll: ' + response.statusCode.toString());
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future deactivateCatchAll(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/$kCatchAllDomainURL/$domainID';
      final response = await dio.delete(path);
      log('deactivateCatchAll: ' + response.statusCode.toString());
    } catch (e) {
      rethrow;
    }
  }
}
