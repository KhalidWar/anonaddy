import 'package:anonaddy/features/app_version/data/app_version_service.dart';
import 'package:anonaddy/features/app_version/domain/app_version_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_dio.dart';

void main() async {
  late MockDio mockDio;
  late AppVersionService appVersionService;

  setUp(() {
    mockDio = MockDio();
    appVersionService = AppVersionService(dio: mockDio);
  });

  test(
      'Given appVersionService and dio are up and running, '
      'When appVersionService.getAppVersionData(path) is called, '
      'Then future completes and returns an appVersion data.', () async {
    // Arrange
    const path = 'path';

    // Act
    final dioGet = mockDio.get(path);
    final appVersion = await appVersionService.getAppVersionData(path);

    // Assert
    expectLater(dioGet, completes);
    expect(await dioGet, isA<Response>());

    expect(appVersion, isA<AppVersion>());
    expect(appVersion.version, isA<String>());
    expect(appVersion.major, isA<int>());
  });

  test(
      'Given appVersionService and dio are up and running, '
      'When appVersionService.getAppVersionData(error) is called, '
      'Then throw an dioError.', () async {
    // Arrange
    const path = 'error';

    // Act
    final dioGet = mockDio.get(path);
    final dioError = isA<DioError>();
    final throwsDioError = throwsA(dioError);

    // Assert
    expectLater(dioGet, throwsException);
    expect(dioGet, throwsDioError);
  });
}
