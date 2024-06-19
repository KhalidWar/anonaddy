import 'dart:async';
import 'dart:developer';

import 'package:anonaddy/common/constants/app_strings.dart';
import 'package:anonaddy/common/constants/url_strings.dart';
import 'package:anonaddy/common/dio_client/dio_client.dart';
import 'package:anonaddy/features/alert_center/domain/failed_delivery.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final failedDeliveryService =
    Provider.autoDispose<FailedDeliveryService>((ref) {
  return FailedDeliveryService(dio: ref.read(dioProvider));
});

class FailedDeliveryService {
  const FailedDeliveryService({required this.dio});

  final Dio dio;

  Future<List<FailedDelivery>> getFailedDeliveries() async {
    try {
      const urlPath = '$kUnEncodedBaseURL/failed-deliveries';
      final response = await dio.get(urlPath);
      final deliveries = response.data['data'];
      log('getFailedDeliveries: ${response.statusCode}');

      return (deliveries as List).map((delivery) {
        return FailedDelivery.fromJson(delivery);
      }).toList();
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      throw 'Failed to fetch failed deliveries';
    }
  }

  Future<FailedDelivery> getSpecificFailedDelivery(String id) async {
    try {
      final urlPath = '$kUnEncodedBaseURL/failed-deliveries/$id';
      final response = await dio.get(urlPath);
      final failedDelivery = response.data['data'];
      log('getSpecificFailedDelivery: ${response.statusCode}');
      return FailedDelivery.fromJson(failedDelivery);
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      throw 'Failed to fetch failed delivery';
    }
  }

  Future<void> deleteFailedDelivery(String failedDeliveryId) async {
    try {
      final path = '$kUnEncodedBaseURL/failed-deliveries/$failedDeliveryId';
      final response = await dio.delete(path);
      log('deleteFailedDelivery: ${response.statusCode}');
    } on DioException catch (dioException) {
      throw dioException.message ?? AppStrings.somethingWentWrong;
    } catch (e) {
      throw throw 'Failed to delete a failed deliveries';
    }
  }
}
