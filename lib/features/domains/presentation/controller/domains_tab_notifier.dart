import 'dart:async';

import 'package:anonaddy/features/domains/data/domains_service.dart';
import 'package:anonaddy/features/domains/domain/domain_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainsNotifierProvider =
    AsyncNotifierProvider<DomainsTabNotifier, List<Domain>>(
        DomainsTabNotifier.new);

class DomainsTabNotifier extends AsyncNotifier<List<Domain>> {
  Future<void> fetchDomains({bool showLoading = false}) async {
    try {
      if (showLoading) state = const AsyncLoading();
      final domains = await ref.read(domainService).fetchDomains();
      state = AsyncData(domains);
    } catch (error) {
      state = AsyncError(error.toString(), StackTrace.empty);
      await _retryOnError();
    }
  }

  Future _retryOnError() async {
    if (state is AsyncError) {
      await Future.delayed(const Duration(seconds: 5));
      await fetchDomains();
    }
  }

  @override
  FutureOr<List<Domain>> build() async {
    final service = ref.read(domainService);

    final domains = await service.loadDomainsFromDisk();
    if (domains == null) return await service.fetchDomains();
    return domains;
  }
}
