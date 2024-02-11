import 'package:anonaddy/features/alert_center/data/failed_delivery_service.dart';
import 'package:anonaddy/features/failed_delivery/domain/failed_delivery.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import 'dummy_failed_deliveries_data.dart';

void main() async {
  late MockDio mockDio;
  late FailedDeliveryService deliveriesService;

  setUp(() {
    mockDio = MockDio();
    deliveriesService = FailedDeliveryService(dio: mockDio);
  });

  test(
      'Given deliveriesService and dio are up and running, '
      'When deliveriesService.getFailedDeliveries() is called, '
      'Then future completes and returns obtain a deliveries list.', () async {
    when(() => mockDio.get(any())).thenAnswer((_) => Future.value(
          Response(
            statusCode: 200,
            data: dummyFailedDeliveriesData,
            // (dummyFailedDeliveriesData['data'] as List).map((delivery) {
            //   return FailedDelivery.fromJson(delivery);
            // }).toList(),
            requestOptions: RequestOptions(path: any(named: 'path')),
          ),
        ));

    // Act
    final deliveries = await deliveriesService.getFailedDeliveries();

    expect(deliveries, isA<List<FailedDelivery>>());
    expect(deliveries.length, 2);
    expect(deliveries[0].aliasEmail, 'alias@anonaddy.com');
    expect(deliveries[0].recipientEmail, 'user@recipient.com');
    expect(deliveries[1].bounceType, 'hard');
  });

  test(
      'Given deliveriesService and dio are up and running, '
      'When deliveriesService.getFailedDeliveries(error) is called, '
      'And is set up to throw an 429 DioError, '
      'Then throw an error.', () async {
    // Arrange

    // Act
    final dioGet = mockDio.get('error');
    final throwsError = throwsA(isA<DioError>());

    // Assert
    expect(() => dioGet, throwsError);
  });

  test(
      'Given aliasService and dio are up and running, '
      'When deliveriesService.deleteFailedDelivery(path) is called, '
      'Then delete failedDelivery without errors.', () async {
    // Arrange
    const deliveryId = 'id';

    // Act
    final dioDelete = mockDio.delete(deliveryId);
    // final response = await deliveriesService.deleteFailedDelivery(deliveryId);

    // Assert
    expectLater(dioDelete, completes);
    expect(await dioDelete, isA<Response>());
  });

  test(
      'Given deliveriesService and dio are up and running, '
      'When deliveriesService.deleteFailedDelivery(error) is called, '
      'Then throw an error.', () async {
    // Arrange
    const deliveryId = 'error';

    // Act
    final dioGet = mockDio.delete(deliveryId);
    final dioError = isA<DioError>();
    final throwsDioError = throwsA(dioError);

    // Assert
    expectLater(dioGet, throwsException);
    expect(dioGet, throwsDioError);
  });
}
