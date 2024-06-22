import 'dart:async';

import 'package:anonaddy/features/domains/data/domains_service.dart';
import 'package:anonaddy/features/domains/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainsNotifierProvider =
    AsyncNotifierProvider.autoDispose<DomainsTabNotifier, List<Domain>>(
        DomainsTabNotifier.new);

class DomainsTabNotifier extends AutoDisposeAsyncNotifier<List<Domain>> {
  Future<void> fetchDomains({bool showLoading = false}) async {
    if (showLoading) state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => ref.read(domainService).fetchDomains());
  }

  @override
  FutureOr<List<Domain>> build() async {
    final service = ref.read(domainService);

    final domains = await service.loadCachedData();
    if (domains != null) return domains;

    return await service.fetchDomains();
  }
}
