import 'package:anonaddy/features/alert_center/data/failed_delivery_service.dart';
import 'package:anonaddy/features/alert_center/domain/failed_delivery.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../test_data/failed_deliveries_test_data.dart';

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
            data: FailedDeliveriesTestData.validFailedDeliveriesJson,
            requestOptions: RequestOptions(path: 'path'),
          ),
        ));

    final deliveries = await deliveriesService.getFailedDeliveries();

    expect(deliveries, isA<List<FailedDelivery>>());
    expect(deliveries.length, 2);
    expect(deliveries[0].aliasEmail, 'alias@anonaddy.com');
    expect(deliveries[0].recipientEmail, 'user@recipient.com');
    expect(deliveries[1].bounceType, 'hard');
    verify(() => mockDio.get(any())).called(1);
  });

  // test(
  //     'Given deliveriesService and dio are up and running, '
  //     'When deliveriesService.getFailedDeliveries(error) is called, '
  //     'And is set up to throw an 429 DioError, '
  //     'Then throw an error.', () async {
  //   when(() => mockDio.get(any())).thenThrow(DioError(
  //     requestOptions: RequestOptions(path: 'path'),
  //     error: 'error',
  //   ));
  //
  //   final deliveries = deliveriesService.getFailedDeliveries();
  //
  //   expect(await deliveries, isA<DioError>());
  //   verify(() => mockDio.delete(any())).called(1);
  // });

  test(
      'Given deliveriesService and dio are up and running, '
      'When deliveriesService.deleteFailedDelivery() is called, '
      'Then future completes and returns obtain a deliveries list.', () async {
    when(() => mockDio.delete(any())).thenAnswer((_) => Future.value(
          Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: 'path'),
          ),
        ));

    final deleteFailedDelivery = deliveriesService.deleteFailedDelivery;

    expect(deleteFailedDelivery('id'), completes);
    verify(() => mockDio.delete(any())).called(1);
  });

  // test(
  //     'Given deliveriesService and dio are up and running, '
  //     'When deliveriesService.deleteFailedDelivery(error) is called, '
  //     'And is set up to throw an 429 DioError, '
  //     'Then throw an error.', () async {
  //   when(() => mockDio.get(any())).thenThrow(DioError(
  //     requestOptions: RequestOptions(path: 'path'),
  //     error: 'error',
  //   ));
  //
  //   final deliveries = deliveriesService.deleteFailedDelivery('id');
  //
  //   expect(deliveries, isA<DioError>());
  //   verify(() => mockDio.delete(any())).called(1);
  // });
}
