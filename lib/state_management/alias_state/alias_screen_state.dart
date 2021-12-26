import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/screens/alias_tab/alias_screen.dart';

/// Status for when fetching [alias] data
enum AliasScreenStatus { loading, loaded, failed }

/// States which [AliasScreen] and its components can be in
class AliasScreenState {
  const AliasScreenState({
    this.status,
    this.alias,
    this.errorMessage,
    this.isToggleLoading,
    this.deleteAliasLoading,
    this.updateRecipientLoading,
    this.isOffline,
  });

  /// [AliasScreen] status when fetching for [alias]
  final AliasScreenStatus? status;

  /// Alias shown in [AliasScreen]
  final Alias? alias;
  final String? errorMessage;

  final bool? isToggleLoading;
  final bool? deleteAliasLoading;
  final bool? updateRecipientLoading;
  final bool? isOffline;

  static AliasScreenState initialState() {
    /// Initializing [AliasScreen] state to avoid null exception
    /// Then call [.copyWith()] method to update specific state variable
    return AliasScreenState(
      status: AliasScreenStatus.loading,
      errorMessage: '',
      isToggleLoading: false,
      deleteAliasLoading: false,
      updateRecipientLoading: false,
      isOffline: false,
    );
  }

  AliasScreenState copyWith({
    AliasScreenStatus? status,
    Alias? alias,
    String? errorMessage,
    bool? isToggleLoading,
    bool? deleteAliasLoading,
    bool? updateRecipientLoading,
    bool? isOffline,
  }) {
    return AliasScreenState(
      status: status ?? this.status,
      alias: alias ?? this.alias,
      errorMessage: errorMessage ?? this.errorMessage,
      isToggleLoading: isToggleLoading ?? this.isToggleLoading,
      deleteAliasLoading: deleteAliasLoading ?? this.deleteAliasLoading,
      updateRecipientLoading:
          updateRecipientLoading ?? this.updateRecipientLoading,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  String toString() {
    return 'AliasScreenState{status: $status, alias: $alias, errorMessage: $errorMessage}';
  }
}
