import 'package:json_annotation/json_annotation.dart';

part 'failed_deliveries_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FailedDeliveriesModel {
  const FailedDeliveriesModel({required this.failedDeliveries});

  @JsonKey(name: 'data')
  final List<FailedDeliveries> failedDeliveries;

  factory FailedDeliveriesModel.fromJson(Map<String, dynamic> json) =>
      _$FailedDeliveriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$FailedDeliveriesModelToJson(this);
}

@JsonSerializable()
class FailedDeliveries {
  const FailedDeliveries({
    required this.id,
    required this.userId,
    required this.recipientId,
    required this.recipientEmail,
    required this.aliasId,
    required this.aliasEmail,
    required this.bounceType,
    required this.remoteMta,
    required this.sender,
    required this.emailType,
    required this.status,
    required this.code,
    required this.attemptedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'recipient_id')
  final String recipientId;
  @JsonKey(name: 'recipient_email')
  final String recipientEmail;
  @JsonKey(name: 'alias_id')
  final String aliasId;
  @JsonKey(name: 'alias_email')
  final String aliasEmail;
  @JsonKey(name: 'bounce_type')
  final String bounceType;
  @JsonKey(name: 'remote_mta')
  final String remoteMta;
  final String sender;
  @JsonKey(name: 'email_type')
  final String emailType;
  final String status;
  final String code;
  @JsonKey(name: 'attempted_at')
  final DateTime attemptedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory FailedDeliveries.fromJson(Map<String, dynamic> json) =>
      _$FailedDeliveriesFromJson(json);

  Map<String, dynamic> toJson() => _$FailedDeliveriesToJson(this);
}
