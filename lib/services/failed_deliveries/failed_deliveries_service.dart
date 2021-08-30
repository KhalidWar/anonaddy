import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:anonaddy/utilities/api_message_handler.dart';
import 'package:http/http.dart' as http;

class FailedDeliveriesService {
  final _accessTokenService = AccessTokenService();

  Future<FailedDeliveriesModel> getFailedDeliveries() async {
    final accessToken = await _accessTokenService.getAccessToken();
    final instanceURL = await _accessTokenService.getInstanceURL();

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
        throw APIMessageHandler().getStatusCodeMessage(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

//todo add search recipient by email
//todo search alias by id
//todo search alias by email
}
