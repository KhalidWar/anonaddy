import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:anonaddy/features/aliases/presentation/alias_screen.dart';

/// States which [AliasScreen] and its components can be in
class AliasScreenState {
  const AliasScreenState({
    required this.alias,
    required this.isToggleLoading,
    required this.deleteAliasLoading,
    required this.updateRecipientLoading,
  });

  /// Alias shown in [AliasScreen]
  final Alias alias;
  final bool isToggleLoading;
  final bool deleteAliasLoading;
  final bool updateRecipientLoading;

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
    );
  }

  @override
  String toString() {
    return 'alias: $alias, isToggleLoading: $isToggleLoading, deleteAliasLoading: $deleteAliasLoading, updateRecipientLoading: $updateRecipientLoading}';
  }
}
