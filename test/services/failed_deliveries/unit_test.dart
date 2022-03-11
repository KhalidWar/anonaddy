import 'package:anonaddy/models/failed_deliveries/failed_deliveries_model.dart';
import 'package:anonaddy/services/access_token/access_token_service.dart';
import 'package:anonaddy/services/failed_deliveries/failed_deliveries_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_dio.dart';

class MockFailedDeliveries extends Mock implements FailedDeliveries {}

class MockAccessTokenService extends Mock implements AccessTokenService {}

void main() async {
  late MockAccessTokenService mockAccessTokenService;
  late MockDio mockDio;
  late FailedDeliveriesService deliveriesService;

  setUp(() {
    mockAccessTokenService = MockAccessTokenService();
    mockDio = MockDio();
    deliveriesService =
        FailedDeliveriesService(mockAccessTokenService, mockDio);
  });

  test(
      'Given deliveriesService and dio are up and running, '
      'When deliveriesService.getFailedDeliveries() is called, '
      'Then future completes and returns obtain a deliveries list.', () async {
    // Arrange
    const path = 'path';

    // Act
    final dioGet = mockDio.get(path);
    final deliveries = await deliveriesService.getFailedDeliveries();

    // Assert
    expectLater(dioGet, completes);
    expect(await dioGet, isA<Response>());

    expect(deliveries, isA<List<FailedDeliveries>>());
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
}
