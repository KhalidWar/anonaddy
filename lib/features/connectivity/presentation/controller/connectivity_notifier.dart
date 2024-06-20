import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _connectivityServiceProvider =
    Provider.autoDispose((ref) => Connectivity());

final connectivityNotifierProvider = StreamNotifierProvider.autoDispose<
    ConnectivityNotifier, ConnectivityResult>(ConnectivityNotifier.new);

class ConnectivityNotifier
    extends AutoDisposeStreamNotifier<ConnectivityResult> {
  @override
  Stream<ConnectivityResult> build() async* {
    final connectivity = ref.read(_connectivityServiceProvider);
    final stream = StreamController<ConnectivityResult>();

    connectivity.onConnectivityChanged.listen((connectivityResult) {
      stream.add(connectivityResult);
    });

    yield* stream.stream;
  }
}

extension ConnectivityResultExtension on ConnectivityResult? {
  bool get hasConnection =>
      this == ConnectivityResult.mobile ||
      this == ConnectivityResult.wifi ||
      this == ConnectivityResult.mobile ||
      this == ConnectivityResult.vpn;

  bool get hasNoConnection => this == ConnectivityResult.none;
}
