import 'dart:developer';

import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class SearchService {
  const SearchService(this.dio);
  final Dio dio;

  /// Fetches matching aliases from API
  Future<List<Alias>> searchAliases(
      String searchKeyword, bool includeDeleted) async {
    try {
      final path = '$kUnEncodedBaseURL/$kAliasesURL';
      final params = {
        'deleted': includeDeleted ? 'with' : null,
        "filter[search]": searchKeyword,
      };

      final response = await dio.get(path, queryParameters: params);
      log('searchAliases: ' + response.statusCode.toString());

      final aliasesList = response.data['data'] as List;
      return aliasesList.map((alias) => Alias.fromJson(alias)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
