import 'package:anonaddy/models/domain/domain_model.dart';

enum DomainsStatus { loading, loaded, failed }

class DomainsState {
  const DomainsState({
    required this.status,
    this.domainModel,
    this.errorMessage,
  });

  final DomainsStatus status;
  final DomainModel? domainModel;
  final String? errorMessage;
}
