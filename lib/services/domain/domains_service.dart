import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/domain/domain_model.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainService = Provider<DomainsService>((ref) {
  return DomainsService(dio: ref.read(dioProvider));
});

class DomainsService {
  const DomainsService({required this.dio});
  final Dio dio;

  Future<List<Domain>> getDomains() async {
    try {
      const path = '$kUnEncodedBaseURL/domains';
      final response = await dio.get(path);
      log('getDomains: ${response.statusCode}');
      final domains = response.data['data'] as List;
      return domains.map((domain) => Domain.fromJson(domain)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> getSpecificDomain(String domainId) async {
    try {
      final path = '$kUnEncodedBaseURL/domains/$domainId';
      final response = await dio.get(path);
      log('getSpecificDomain: ${response.statusCode}');
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> addNewDomain(String domain) async {
    try {
      const path = '$kUnEncodedBaseURL/domains';
      final data = json.encode({"domain": domain});
      final response = await dio.post(path, data: data);
      log('addNewDomain: ${response.statusCode}');
      final newDomain = response.data['data'];
      return Domain.fromJson(newDomain);
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> updateDomainDescription(
      String domainID, String description) async {
    try {
      final path = '$kUnEncodedBaseURL/domains/$domainID';
      final data = jsonEncode({"description": description});
      final response = await dio.patch(path, data: data);
      log('updateDomainDescription: ${response.statusCode}');
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDomain(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/domains/$domainID';
      final response = await dio.delete(path);
      log('deleteDomain: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> updateDomainDefaultRecipient(
      String domainID, String recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/domains/$domainID/default-recipient';
      final data = jsonEncode({"default_recipient": recipientID});
      final response = await dio.patch(path, data: data);
      log('updateDomainDefaultRecipient: ${response.statusCode}');
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> activateDomain(String domainID) async {
    try {
      const path = '$kUnEncodedBaseURL/active-domains';
      final data = json.encode({"id": domainID});
      final response = await dio.post(path, data: data);
      log('activateDomain: ${response.statusCode}');
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateDomain(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/active-domains/$domainID';
      final response = await dio.delete(path);
      log('deactivateDomain: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> activateCatchAll(String domainID) async {
    try {
      const path = '$kUnEncodedBaseURL/catch-all-domains';
      final data = json.encode({"id": domainID});
      final response = await dio.post(path, data: data);
      log('activateCatchAll: ${response.statusCode}');
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } catch (e) {
      rethrow;
    }
  }

  Future deactivateCatchAll(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/catch-all-domains/$domainID';
      final response = await dio.delete(path);
      log('deactivateCatchAll: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}
