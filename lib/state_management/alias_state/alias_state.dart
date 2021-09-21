import 'package:anonaddy/models/alias/alias_model.dart';

enum AliasTabStatus { loading, loaded, failed }

class AliasState {
  const AliasState({required this.status, this.aliasModel, this.errorMessage});

  final AliasTabStatus status;
  final AliasModel? aliasModel;
  final String? errorMessage;
}
