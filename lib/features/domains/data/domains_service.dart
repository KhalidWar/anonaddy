import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/domains/data/domains_data_storage.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainService = Provider.autoDispose<DomainsService>((ref) {
  return DomainsService(
    dio: ref.read(dioProvider),
    dataStorage: ref.read(domainsDataStorageProvider),
  );
});

class DomainsService {
  const DomainsService({
    required this.dio,
    required this.dataStorage,
  });

  final Dio dio;
  final DomainsDataStorage dataStorage;

  Future<List<Domain>> fetchDomains() async {
    try {
      const path = '$kUnEncodedBaseURL/domains';
      final response = await dio.get(path);
      log('getDomains: ${response.statusCode}');
      dataStorage.saveData(response.data);
      final domains = response.data['data'] as List;
      return domains.map((domain) => Domain.fromJson(domain)).toList();
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final domains = await dataStorage.loadData();
        if (domains != null) return domains;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> fetchSpecificDomain(String domainId) async {
    try {
      final path = '$kUnEncodedBaseURL/domains/$domainId';
      final response = await dio.get(path);
      log('getSpecificDomain: ${response.statusCode}');
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } on DioException catch (dioException) {
      if (dioException.type == DioExceptionType.connectionError) {
        final domain = await dataStorage.loadSpecificDomain(domainId);
        return domain;
      }
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDomain(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/domains/$domainID';
      final response = await dio.delete(path);
      log('deleteDomain: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<Domain> updateDomainDefaultRecipient(
      String domainID, String? recipientID) async {
    try {
      final path = '$kUnEncodedBaseURL/domains/$domainID/default-recipient';
      final data = jsonEncode({"default_recipient": recipientID});
      final response = await dio.patch(path, data: data);
      log('updateDomainDefaultRecipient: ${response.statusCode}');
      final domain = response.data['data'];
      return Domain.fromJson(domain);
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateDomain(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/active-domains/$domainID';
      final response = await dio.delete(path);
      log('deactivateDomain: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
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
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future deactivateCatchAll(String domainID) async {
    try {
      final path = '$kUnEncodedBaseURL/catch-all-domains/$domainID';
      final response = await dio.delete(path);
      log('deactivateCatchAll: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Domain>?> loadDomainsFromDisk() async {
    try {
      return await dataStorage.loadData();
    } catch (error) {
      rethrow;
    }
  }
}
