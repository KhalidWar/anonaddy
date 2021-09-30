import 'package:anonaddy/models/alias/alias_model.dart';

enum SearchHistoryStatus { loading, loaded, failed }

class SearchHistoryState {
  const SearchHistoryState({
    required this.status,
    required this.aliases,
    this.errorMessage,
  });

  final SearchHistoryStatus status;
  final List<Alias> aliases;
  final String? errorMessage;

  SearchHistoryState copyWith({
    SearchHistoryStatus? status,
    List<Alias>? aliases,
    String? errorMessage,
  }) {
    return SearchHistoryState(
      status: status ?? this.status,
      aliases: aliases ?? this.aliases,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'SearchState{status: $status, aliases: $aliases, errorMessage: $errorMessage}';
  }
}
