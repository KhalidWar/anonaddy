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

  static Account dummy() {
    return Account.fromJson({
      "id": "50c9e585-e7f5-41c4-9016-9014c15454bc",
      "username": "johndoe",
      "from_name": "John Doe",
      "email_subject": "Private Subject",
      "banner_location": "off",
      "bandwidth": 10485760,
      "username_count": 2,
      "username_limit": 3,
      "default_recipient_id": "46eebc50-f7f8-46d7-beb9-c37f04c29a84",
      "default_alias_domain": "anonaddy.me",
      "default_alias_format": "random_words",
      "subscription": "free",
      "subscription_ends_at": null,
      "bandwidth_limit": 0,
      "recipient_count": 12,
      "recipient_limit": 20,
      "active_domain_count": 4,
      "active_domain_limit": 10,
      "active_shared_domain_alias_count": 50,
      "active_shared_domain_alias_limit": 0,
      "total_emails_forwarded": 488,
      "total_emails_blocked": 6,
      "total_emails_replied": 95,
      "total_emails_sent": 17,
      "created_at": "2019-10-01 09:00:00",
      "updated_at": "2019-10-01 09:00:00"
    });
  }

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  String toString() {
    return 'Account{id: $id, username: $username, fromName: $fromName, emailSubject: $emailSubject, bannerLocation: $bannerLocation, bandwidth: $bandwidth, bandwidthLimit: $bandwidthLimit, usernameCount: $usernameCount, usernameLimit: $usernameLimit, defaultRecipientId: $defaultRecipientId, defaultAliasDomain: $defaultAliasDomain, defaultAliasFormat: $defaultAliasFormat, subscription: $subscription, subscriptionEndAt: $subscriptionEndAt, recipientCount: $recipientCount, recipientLimit: $recipientLimit, activeDomainCount: $activeDomainCount, activeDomainLimit: $activeDomainLimit, aliasCount: $aliasCount, aliasLimit: $aliasLimit, totalEmailsForwarded: $totalEmailsForwarded, totalEmailsBlocked: $totalEmailsBlocked, totalEmailsReplied: $totalEmailsReplied, totalEmailsSent: $totalEmailsSent, createdAt: $createdAt, lastUpdated: $lastUpdated}';
  }
}
