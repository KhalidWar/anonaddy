import 'package:anonaddy/features/account/domain/account.dart';

class AccountTestData {
  static Account validAccount() {
    return Account(
      id: 'id',
      username: 'khalidwar',
      fromName: '',
      emailSubject: '',
      bannerLocation: '',
      bandwidth: 0,
      bandwidthLimit: 100,
      usernameCount: 5,
      usernameLimit: 10,
      defaultRecipientId: '756c3e48-a15a-4a9b-90c3-dbd97fef5274',
      defaultAliasDomain: 'laylow.io',
      defaultAliasFormat: '',
      recipientCount: 3,
      recipientLimit: 100,
      activeDomainCount: 0,
      activeDomainLimit: 100,
      totalEmailsForwarded: 1,
      totalEmailsBlocked: 0,
      totalEmailsReplied: 0,
      totalEmailsSent: 0,
      createdAt: DateTime(2021, 7, 28),
      updatedAt: DateTime(2022, 3, 1),
      aliasCount: 10,
      aliasLimit: 100,
      subscription: '',
      subscriptionEndAt: '',
      // "active_shared_domain_alias_count": 1548,
    );
  }

  static const validAccountJson = <String, dynamic>{
    "data": {
      "id": "id",
      "username": "khalidwar",
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
    }
  };
}
