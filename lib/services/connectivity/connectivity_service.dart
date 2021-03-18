import 'dart:async';

import 'package:connectivity/connectivity.dart';

enum ConnectionStatus { online, offline }

class ConnectivityService {
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      final status = _getStatus(result);
      streamController.add(status);
    });
  }

  final streamController = StreamController<ConnectionStatus>();

  ConnectionStatus _getStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none:
        return ConnectionStatus.offline;
      default:
        return ConnectionStatus.online;
    }
  }
}
