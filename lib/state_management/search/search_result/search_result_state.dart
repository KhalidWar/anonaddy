import 'package:anonaddy/models/alias/alias.dart';
import 'package:flutter/cupertino.dart';

enum SearchResultStatus { Initial, Limited, Loading, Loaded, Failed }

class SearchResultState {
  SearchResultState({
    required this.status,
    this.aliases,
    this.errorMessage,
    this.searchController,
    this.showCloseIcon,
    this.includeDeleted,
  });

  SearchResultStatus status;
  List<Alias>? aliases;
  String? errorMessage;
  TextEditingController? searchController;
  bool? showCloseIcon;
  bool? includeDeleted;

  static SearchResultState initial(
      TextEditingController controller, bool includeDeleted) {
    return SearchResultState(
      status: SearchResultStatus.Initial,
      aliases: [],
      errorMessage: '',
      searchController: controller,
      showCloseIcon: false,
      includeDeleted: includeDeleted,
    );
  }

  SearchResultState copyWith({
    SearchResultStatus? status,
    List<Alias>? aliases,
    String? errorMessage,
    TextEditingController? searchController,
    bool? showCloseIcon,
    bool? includeDeleted,
  }) {
    return SearchResultState(
      status: status ?? this.status,
      aliases: aliases ?? this.aliases,
      errorMessage: errorMessage ?? this.errorMessage,
      searchController: searchController ?? this.searchController,
      showCloseIcon: showCloseIcon ?? this.showCloseIcon,
      includeDeleted: includeDeleted ?? this.includeDeleted,
    );
  }

  @override
  String toString() {
    return 'SearchResultState{status: $status, controller: ${searchController!.text} showCloseIcon: $showCloseIcon, includeDeleted: $includeDeleted}';
  }
}
