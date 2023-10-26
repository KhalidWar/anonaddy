import 'dart:async';

import 'package:anonaddy/models/domain_options/domain_options.dart';
import 'package:anonaddy/services/domain_options/domain_options_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final domainOptionsNotifier =
    AsyncNotifierProvider<DomainOptionsNotifier, DomainOptions>(
        DomainOptionsNotifier.new);

class DomainOptionsNotifier extends AsyncNotifier<DomainOptions> {
  Future<void> fetchDomainOption() async {
    try {
      final domainOptions =
          await ref.read(domainOptionsService).fetchDomainOptions();
      state = AsyncValue.data(domainOptions);
    } catch (error) {
      rethrow;
    }
  }

  @override
  FutureOr<DomainOptions> build() async {
    final domainService = ref.read(domainOptionsService);
    final domainOptions = await domainService.fetchDomainOptions();

    return domainOptions;
  }
}
