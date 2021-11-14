import 'package:anonaddy/models/alias/alias.dart';

enum AliasScreenStatus { loading, loaded, failed }

class AliasScreenState {
  const AliasScreenState({
    this.status,
    this.alias,
    this.errorMessage,
    this.isToggleLoading,
    this.deleteAliasLoading,
    this.updateRecipientLoading,
  });

  final AliasScreenStatus? status;
  final Alias? alias;
  final String? errorMessage;

  final bool? isToggleLoading;
  final bool? deleteAliasLoading;
  final bool? updateRecipientLoading;

  static AliasScreenState initialState() {
    /// Initializing [AliasScreen] state to avoid null exception
    /// Then call [.copyWith()] method to update specific state variable
    return AliasScreenState(
      status: AliasScreenStatus.loading,
      errorMessage: '',
      isToggleLoading: false,
      deleteAliasLoading: false,
      updateRecipientLoading: false,
    );
  }

  AliasScreenState copyWith({
    AliasScreenStatus? status,
    Alias? alias,
    String? errorMessage,
    bool? isToggleLoading,
    bool? deleteAliasLoading,
    bool? updateRecipientLoading,
  }) {
    return AliasScreenState(
      status: status ?? this.status,
      alias: alias ?? this.alias,
      errorMessage: errorMessage ?? this.errorMessage,
      isToggleLoading: isToggleLoading ?? this.isToggleLoading,
      deleteAliasLoading: deleteAliasLoading ?? this.deleteAliasLoading,
      updateRecipientLoading:
          updateRecipientLoading ?? this.updateRecipientLoading,
    );
  }

  @override
  String toString() {
    return 'AliasScreenState{status: $status, alias: $alias, errorMessage: $errorMessage}';
  }
}
