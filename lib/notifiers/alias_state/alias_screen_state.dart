import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';
import 'package:anonaddy/models/alias/alias.dart';

/// States which [AliasScreen] and its components can be in
class AliasScreenState {
  const AliasScreenState({
    required this.alias,
    required this.isToggleLoading,
    required this.deleteAliasLoading,
    required this.updateRecipientLoading,
    required this.isOffline,
  });

  /// Alias shown in [AliasScreen]
  final Alias alias;
  final bool isToggleLoading;
  final bool deleteAliasLoading;
  final bool updateRecipientLoading;
  final bool isOffline;

  AliasScreenState copyWith({
    Alias? alias,
    String? errorMessage,
    bool? isToggleLoading,
    bool? deleteAliasLoading,
    bool? updateRecipientLoading,
    bool? isOffline,
  }) {
    return AliasScreenState(
      alias: alias ?? this.alias,
      isToggleLoading: isToggleLoading ?? this.isToggleLoading,
      deleteAliasLoading: deleteAliasLoading ?? this.deleteAliasLoading,
      updateRecipientLoading:
          updateRecipientLoading ?? this.updateRecipientLoading,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  String toString() {
    return 'alias: $alias, isToggleLoading: $isToggleLoading, deleteAliasLoading: $deleteAliasLoading, updateRecipientLoading: $updateRecipientLoading, isOffline: $isOffline}';
  }
}
