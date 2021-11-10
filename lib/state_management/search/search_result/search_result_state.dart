import 'package:anonaddy/models/alias/alias.dart';

enum SearchResultStatus { Initial, Empty, Loaded, Error }

class SearchResultState {
  SearchResultState({
    required this.isSearching,
    required this.aliases,
  });
  bool isSearching;
  List<Alias> aliases;

  static SearchResultState initial() {
    return SearchResultState(isSearching: false, aliases: []);
  }

  SearchResultState copyWith({
    bool? isSearching,
    List<Alias>? aliases,
  }) {
    return SearchResultState(
      isSearching: isSearching ?? this.isSearching,
      aliases: aliases ?? this.aliases,
    );
  }
}
