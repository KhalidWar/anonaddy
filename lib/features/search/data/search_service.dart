import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/aliases/domain/alias.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(dio: ref.read(dioProvider));
});

class SearchService {
  const SearchService({required this.dio});
  final Dio dio;

  /// Fetches matching aliases from API
  Future<List<Alias>> searchAliases(
      String searchKeyword, CancelToken? cancelToken) async {
    try {
      const path = '$kUnEncodedBaseURL/aliases';
      final params = {"filter[search]": searchKeyword};

      final response = await dio.get(
        path,
        queryParameters: params,
        cancelToken: cancelToken,
      );

      log('searchAliases: ${response.statusCode}');

      final aliasesList = response.data['data'] as List;
      return aliasesList.map((alias) => Alias.fromJson(alias)).toList();
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      rethrow;
    }
  }
}
