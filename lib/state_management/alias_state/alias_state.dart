import 'package:anonaddy/models/alias/alias_model.dart';

enum AliasStatus { loading, loaded, failed }

class AliasState {
  const AliasState({
    required this.status,
    this.aliasModel,
    this.errorMessage,
  });

  final AliasStatus status;
  final AliasModel? aliasModel;
  final String? errorMessage;
}
