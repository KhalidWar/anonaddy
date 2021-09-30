import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStateNotifier =
    StateNotifierProvider.autoDispose<ConnectivityState, ConnectionStatus>(
  (ref) => ConnectivityState(Connectivity()),
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
