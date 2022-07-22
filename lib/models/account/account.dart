import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account {
  Account({
    this.id = '',
    this.username = '',
    this.fromName = '',
    this.emailSubject = '',
    this.bannerLocation = '',
    this.bandwidth = 0,
    this.bandwidthLimit = 0,
    this.usernameCount = 0,
    this.usernameLimit = 0,
    this.defaultRecipientId = '',
    this.defaultAliasDomain = '',
    this.defaultAliasFormat = '',
    this.subscription = '',
    this.subscriptionEndAt = '',
    this.recipientCount = 0,
    this.recipientLimit = 0,
    this.activeDomainCount = 0,
    this.activeDomainLimit = 0,
    this.aliasCount = 0,
    this.aliasLimit = 0,
    this.totalEmailsForwarded = 0,
    this.totalEmailsBlocked = 0,
    this.totalEmailsReplied = 0,
    this.totalEmailsSent = 0,
    this.createdAt = '',
    this.lastUpdated = '',
  });

  final String id;
  final String username;

  @JsonKey(name: 'from_name')
  final String fromName;

  @JsonKey(name: 'email_subject')
  final String emailSubject;

  @JsonKey(name: 'banner_location')
  final String bannerLocation;

  final int bandwidth;

  @JsonKey(name: 'bandwidth_limit')
  final int bandwidthLimit;

  @JsonKey(name: 'username_count')
  final int usernameCount;

  @JsonKey(name: 'username_limit')
  final int usernameLimit;

  @JsonKey(name: 'default_recipient_id')
  final String defaultRecipientId;

  @JsonKey(name: 'default_alias_domain')
  final String defaultAliasDomain;

  @JsonKey(name: 'default_alias_format')
  final String defaultAliasFormat;

  final String subscription;

  @JsonKey(name: 'subscription_ends_at')
  final String subscriptionEndAt;

  @JsonKey(name: 'recipient_count')
  final int recipientCount;

  @JsonKey(name: 'recipient_limit')
  final int recipientLimit;

  @JsonKey(name: 'active_domain_count')
  final int activeDomainCount;

  @JsonKey(name: 'active_domain_limit')
  final int activeDomainLimit;

  @JsonKey(name: 'active_shared_domain_alias_count')
  final int aliasCount;

  @JsonKey(name: 'active_shared_domain_alias_limit')
  final int aliasLimit;

  @JsonKey(name: 'total_emails_forwarded')
  final int totalEmailsForwarded;

  @JsonKey(name: 'total_emails_blocked')
  final int totalEmailsBlocked;

  @JsonKey(name: 'total_emails_replied')
  final int totalEmailsReplied;

  @JsonKey(name: 'total_emails_sent')
  final int totalEmailsSent;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String lastUpdated;

  // static Account dummy() {
  //   return Account.fromJson({
  //     "id": "50c9e585-e7f5-41c4-9016-9014c15454bc",
  //     "username": "johndoe",
  //     "from_name": "John Doe",
  //     "email_subject": "Private Subject",
  //     "banner_location": "off",
  //     "bandwidth": 10485760,
  //     "username_count": 2,
  //     "username_limit": 3,
  //     "default_recipient_id": "46eebc50-f7f8-46d7-beb9-c37f04c29a84",
  //     "default_alias_domain": "anonaddy.me",
  //     "default_alias_format": "random_words",
  //     "subscription": "free",
  //     "subscription_ends_at": null,
  //     "bandwidth_limit": 0,
  //     "recipient_count": 12,
  //     "recipient_limit": 20,
  //     "active_domain_count": 4,
  //     "active_domain_limit": 10,
  //     "active_shared_domain_alias_count": 50,
  //     "active_shared_domain_alias_limit": 0,
  //     "total_emails_forwarded": 488,
  //     "total_emails_blocked": 6,
  //     "total_emails_replied": 95,
  //     "total_emails_sent": 17,
  //     "created_at": "2019-10-01 09:00:00",
  //     "updated_at": "2019-10-01 09:00:00"
  //   });
  // }

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  String toString() {
    return 'Account{id: $id, username: $username, fromName: $fromName, emailSubject: $emailSubject, bannerLocation: $bannerLocation, bandwidth: $bandwidth, bandwidthLimit: $bandwidthLimit, usernameCount: $usernameCount, usernameLimit: $usernameLimit, defaultRecipientId: $defaultRecipientId, defaultAliasDomain: $defaultAliasDomain, defaultAliasFormat: $defaultAliasFormat, subscription: $subscription, subscriptionEndAt: $subscriptionEndAt, recipientCount: $recipientCount, recipientLimit: $recipientLimit, activeDomainCount: $activeDomainCount, activeDomainLimit: $activeDomainLimit, aliasCount: $aliasCount, aliasLimit: $aliasLimit, totalEmailsForwarded: $totalEmailsForwarded, totalEmailsBlocked: $totalEmailsBlocked, totalEmailsReplied: $totalEmailsReplied, totalEmailsSent: $totalEmailsSent, createdAt: $createdAt, lastUpdated: $lastUpdated}';
  }
}
