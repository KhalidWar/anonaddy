import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account {
  Account({
    required this.id,
    required this.username,
    this.fromName,
    this.emailSubject,
    required this.bannerLocation,
    required this.bandwidth,
    required this.bandwidthLimit,
    required this.usernameCount,
    required this.usernameLimit,
    required this.defaultRecipientId,
    this.defaultAliasDomain,
    this.defaultAliasFormat,
    required this.subscription,
    this.subscriptionEndAt,
    required this.recipientCount,
    required this.recipientLimit,
    required this.activeDomainCount,
    required this.activeDomainLimit,
    required this.aliasCount,
    required this.aliasLimit,
    required this.totalEmailsForwarded,
    required this.totalEmailsBlocked,
    required this.totalEmailsReplied,
    required this.totalEmailsSent,
    required this.createdAt,
    required this.lastUpdated,
  });

  String id;
  String username;

  @JsonKey(name: 'from_name')
  String? fromName;

  @JsonKey(name: 'email_subject')
  String? emailSubject;

  @JsonKey(name: 'banner_location')
  String bannerLocation;

  int bandwidth;

  @JsonKey(name: 'bandwidth_limit')
  int? bandwidthLimit;

  @JsonKey(name: 'username_count')
  int? usernameCount;

  @JsonKey(name: 'username_limit')
  int? usernameLimit;

  @JsonKey(name: 'default_recipient_id')
  String defaultRecipientId;

  @JsonKey(name: 'default_alias_domain')
  String? defaultAliasDomain;

  @JsonKey(name: 'default_alias_format')
  String? defaultAliasFormat;

  String? subscription;

  @JsonKey(name: 'subscription_ends_at')
  DateTime? subscriptionEndAt;

  @JsonKey(name: 'recipient_count')
  int? recipientCount;

  @JsonKey(name: 'recipient_limit')
  int? recipientLimit;

  @JsonKey(name: 'active_domain_count')
  int? activeDomainCount;

  @JsonKey(name: 'active_domain_limit')
  int? activeDomainLimit;

  @JsonKey(name: 'active_shared_domain_alias_count')
  int? aliasCount;

  @JsonKey(name: 'active_shared_domain_alias_limit')
  int? aliasLimit;

  @JsonKey(name: 'total_emails_forwarded')
  int totalEmailsForwarded;

  @JsonKey(name: 'total_emails_blocked')
  int totalEmailsBlocked;

  @JsonKey(name: 'total_emails_replied')
  int totalEmailsReplied;

  @JsonKey(name: 'total_emails_sent')
  int totalEmailsSent;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime lastUpdated;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
