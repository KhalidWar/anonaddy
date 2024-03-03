import 'package:json_annotation/json_annotation.dart';

part 'failed_delivery.g.dart';

@JsonSerializable()
class FailedDelivery {
  const FailedDelivery({
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
  final String? recipientId;
  @JsonKey(name: 'recipient_email')
  final String? recipientEmail;
  @JsonKey(name: 'alias_id')
  final String? aliasId;
  @JsonKey(name: 'alias_email')
  final String? aliasEmail;
  @JsonKey(name: 'bounce_type')
  final String bounceType;
  @JsonKey(name: 'remote_mta')
  final String remoteMta;
  final String? sender;
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

  factory FailedDelivery.fromJson(Map<String, dynamic> json) =>
      _$FailedDeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$FailedDeliveryToJson(this);

  @override
  String toString() {
    return 'FailedDelivery{id: $id, userId: $userId, recipientId: $recipientId, recipientEmail: $recipientEmail, aliasId: $aliasId, aliasEmail: $aliasEmail, bounceType: $bounceType, remoteMta: $remoteMta, sender: $sender, emailType: $emailType, status: $status, code: $code, attemptedAt: $attemptedAt, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
