import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/models/failed_delivery/failed_delivery.dart';
import 'package:anonaddy/shared_components/constants/url_strings.dart';
import 'package:dio/dio.dart';

class FailedDeliveriesService {
  const FailedDeliveriesService(this.dio);
  final Dio dio;

  Future<List<FailedDelivery>> getFailedDeliveries([String? path]) async {
    try {
      const urlPath = '$kUnEncodedBaseURL/$kFailedDeliveriesURL';
      final response = await dio.get(path ?? urlPath);
      final deliveries = response.data['data'];
      log('getFailedDeliveries: ' + response.statusCode.toString());

      return (deliveries as List).map((delivery) {
        return FailedDelivery.fromJson(delivery);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteFailedDelivery(String failedDeliveryId) async {
    try {
      final path = '$kUnEncodedBaseURL/$kFailedDeliveriesURL/$failedDeliveryId';
      final response = await dio.delete(path);
      log('deleteFailedDelivery: ' + response.statusCode.toString());

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
