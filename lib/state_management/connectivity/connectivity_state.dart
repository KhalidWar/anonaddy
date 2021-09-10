import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

final connectivityStateProvider =
    StateNotifierProvider<ConnectivityState, ConnectionStatus>(
  (ref) {
    final connectivityProvider = ref.read(connectivityState);
    return connectivityProvider;
  },
);

enum ConnectionStatus { online, offline }

class ConnectivityState extends StateNotifier<ConnectionStatus> {
  ConnectivityState(Connectivity connectivity)
      : super(ConnectionStatus.online) {
    connectivity.onConnectivityChanged.listen((event) {
      final status = _getStatus(event);
      state = status;
    });
  }

  ConnectionStatus _getStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none:
        return ConnectionStatus.offline;
      default:
        return ConnectionStatus.online;
    }
  }
}
