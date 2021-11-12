import 'package:anonaddy/models/domain/domain_model.dart';

enum DomainsTabStatus { loading, loaded, failed }

class DomainsTabState {
  const DomainsTabState({
    required this.status,
    this.domainModel,
    this.errorMessage,
  });

  final DomainsTabStatus status;
  final DomainModel? domainModel;
  final String? errorMessage;
}
