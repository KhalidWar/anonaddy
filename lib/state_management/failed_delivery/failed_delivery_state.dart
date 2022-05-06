import 'package:anonaddy/models/failed_delivery/failed_delivery.dart';

enum FailedDeliveryStatus { loading, loaded, failed }

class FailedDeliveryState {
  const FailedDeliveryState({
    required this.status,
    required this.failedDeliveries,
    required this.errorMessage,
  });

  final FailedDeliveryStatus status;
  final List<FailedDelivery> failedDeliveries;
  final String errorMessage;

  static FailedDeliveryState initialState() {
    return const FailedDeliveryState(
      status: FailedDeliveryStatus.loading,
      failedDeliveries: [],
      errorMessage: '',
    );
  }

  FailedDeliveryState copyWith({
    FailedDeliveryStatus? status,
    List<FailedDelivery>? failedDeliveries,
    String? errorMessage,
  }) {
    return FailedDeliveryState(
      status: status ?? this.status,
      failedDeliveries: failedDeliveries ?? this.failedDeliveries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
