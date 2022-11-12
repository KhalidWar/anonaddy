import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/data_storage/domain_options_data_storage.dart';
import 'package:anonaddy/services/dio_client/dio_interceptors.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsService = Provider<DomainOptionsService>((ref) {
  return DomainOptionsService(
    dio: ref.read(dioProvider),
    dataStorage: ref.read(domainOptionsDataStorageProvider),
  );
});

class DomainOptionsService {
  const DomainOptionsService({
    required this.dio,
    required this.dataStorage,
  });
  final Dio dio;
  final DomainOptionsDataStorage dataStorage;

  Future<DomainOptions> fetchDomainOptions() async {
    try {
      const path = '$kUnEncodedBaseURL/domain-options';
      final response = await dio.get(path);
      dataStorage.saveData(response.data);
      log('fetchDomainOptions: ${response.statusCode}');
      return DomainOptions.fromJson(response.data);
    } on DioError catch (dioError) {
      if (dioError.type == DioErrorType.other) {
        final domains = await dataStorage.loadData();
        return domains;
      }
      throw dioError.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<DomainOptions> loadDataFromDisk() async {
    try {
      final account = await dataStorage.loadData();
      return account;
    } catch (error) {
      rethrow;
    }
  }
}
