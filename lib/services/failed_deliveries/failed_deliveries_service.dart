import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_error_message.dart';
import 'package:http/http.dart' as http;

class FailedDeliveriesService {
  const FailedDeliveriesService(this.accessTokenService);
  final AccessTokenService accessTokenService;

  Future<FailedDeliveriesModel> getFailedDeliveries() async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.get(
        Uri.https(instanceURL, '$kUnEncodedBaseURL/$kFailedDeliveriesURL'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        log('getFailedDeliveries: ' + response.statusCode.toString());
        return FailedDeliveriesModel.fromJson(jsonDecode(response.body));
      } else {
        log('getFailedDeliveries: ' + response.statusCode.toString());
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteFailedDelivery(String failedDeliveryId) async {
    final accessToken = await accessTokenService.getAccessToken();
    final instanceURL = await accessTokenService.getInstanceURL();

    try {
      final response = await http.delete(
        Uri.https(instanceURL,
            '$kUnEncodedBaseURL/$kFailedDeliveriesURL/$failedDeliveryId'),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 204) {
        log('deleteFailedDelivery: ' + response.statusCode.toString());
        return true;
      } else {
        log('deleteFailedDelivery: ' + response.statusCode.toString());
        throw ApiErrorMessage.translateStatusCode(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

//todo add search recipient by email
//todo search alias by id
//todo search alias by email
}
