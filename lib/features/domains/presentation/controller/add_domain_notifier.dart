import 'dart:async';

import 'package:anonaddy/common/utilities.dart';
import 'package:anonaddy/features/domains/data/domains_service.dart';
import 'package:anonaddy/features/domains/presentation/controller/domains_tab_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addDomainNotifierProvider =
    AsyncNotifierProvider.autoDispose<AddDomainNotifier, void>(
        AddDomainNotifier.new);

class AddDomainNotifier extends AutoDisposeAsyncNotifier<void> {
  Future<void> addDomain(String domain) async {
    try {
      state = const AsyncLoading();

      await ref.read(domainService).addNewDomain(domain);
      Utilities.showToast('Domain added successfully!');
      state = const AsyncData(null);

      await ref
          .read(domainsNotifierProvider.notifier)
          .fetchDomains(showLoading: true);
    } catch (error) {
      Utilities.showToast(error.toString());
    }
  }

  @override
  FutureOr<void> build() {
    return null;
  }
}
