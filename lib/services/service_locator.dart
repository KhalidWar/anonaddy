import 'package:anonaddy/services/access_token_service.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/services/network_service.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void initServiceLocator() {
  serviceLocator.registerLazySingleton<APIService>(
    () => APIService(),
  );

  serviceLocator.registerLazySingleton<AccessTokenService>(
    () => AccessTokenService(),
  );

  serviceLocator.registerLazySingleton<NetworkService>(
    () => NetworkService(),
  );
}
