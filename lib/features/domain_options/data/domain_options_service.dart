import 'dart:async';

import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/base_service.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/common/secure_storage.dart';
import 'package:anonaddy/features/domain_options/domain/domain_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsService = Provider.autoDispose<DomainOptionsService>((ref) {
  return DomainOptionsService(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(flutterSecureStorageProvider),
  );
});

class DomainOptionsService extends BaseService {
  const DomainOptionsService({
    required super.dio,
    required super.secureStorage,
  });

  Future<DomainOptions> fetchDomainOptions() async {
    const path = '$kUnEncodedBaseURL/domain-options';
    final response = await get(path);
    return DomainOptions.fromJson(response);
  }
}
