import 'package:anonaddy/models/domain_options/domain_options.dart';

enum DomainOptionsStatus { loading, loaded, failed }

class DomainOptionsState {
  const DomainOptionsState({
    required this.status,
    this.domainOptions,
    this.errorMessage,
  });

  final DomainOptionsStatus status;
  final DomainOptions? domainOptions;
  final String? errorMessage;
}
