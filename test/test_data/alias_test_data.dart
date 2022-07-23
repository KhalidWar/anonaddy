import 'package:anonaddy/models/alias/alias.dart';
import 'package:anonaddy/models/recipient/recipient.dart';

class AliasTestData {
  static Alias defaultAlias() {
    return Alias();
  }

  static Alias validAliasWithRecipients() {
    return Alias(
      id: "fd2258a0-9a40-4825-96c8-ed0f8c38a429",
      userId: "f68d975c-00c4-4eb0-b9d2-2d2a6306265d",
      aliasableId: '',
      aliasableType: '',
      localPart: 'pox.tribute734',
      extension: '',
      domain: 'laylow.io',
      email: 'pox.tribute734@laylow.io',
      active: true,
      description: '',
      emailsForwarded: 0,
      emailsBlocked: 0,
      emailsReplied: 0,
      emailsSent: 0,
      createdAt: '2022-02-22 18:08:15',
      updatedAt: '2022-03-05 19:57:42',
      deletedAt: '',
      recipients: [
        Recipient(
          id: '756c3e48-a15a-4a9b-90c3-dbd97fef5274',
          userId: 'f68d975c-00c4-4eb0-b9d2-2d2a6306265d',
          email: 'test@example.com',
          shouldEncrypt: false,
          // "can_reply_send": true,
          fingerprint: 'B8B58C259795FE02485B9A633E794F5F9FDDB0A8',
          emailVerifiedAt: '2021-07-28 16:42:23',
          createdAt: '2021-07-28 16:41:44',
          updatedAt: '2022-02-25 17:30:01',
        ),
      ],
    );
  }

  static Alias validAliasWithEmptyRecipients() {
    return Alias(
      id: "fd2258a0-9a40-4825-96c8-ed0f8c38a429",
      userId: "f68d975c-00c4-4eb0-b9d2-2d2a6306265d",
      aliasableId: '',
      aliasableType: '',
      localPart: 'pox.tribute734',
      extension: '',
      domain: 'laylow.io',
      email: 'pox.tribute734@laylow.io',
      active: true,
      description: '',
      emailsForwarded: 0,
      emailsBlocked: 0,
      emailsReplied: 0,
      emailsSent: 0,
      createdAt: '2022-02-22 18:08:15',
      updatedAt: '2022-03-05 19:57:42',
      deletedAt: '',
      recipients: [],
    );
  }

  static const validAliasJson = <String, dynamic>{
    "id": "fd2258a0-9a40-4825-96c8-ed0f8c38a429",
    "user_id": "f68d975c-00c4-4eb0-b9d2-2d2a6306265d",
    "aliasable_id": null,
    "aliasable_type": null,
    "local_part": "pox.tribute734",
    "extension": null,
    "domain": "laylow.io",
    "email": "pox.tribute734@laylow.io",
    "active": true,
    "description": null,
    "emails_forwarded": 0,
    "emails_blocked": 0,
    "emails_replied": 0,
    "emails_sent": 0,
    "created_at": "2022-02-22 18:08:15",
    "updated_at": "2022-03-05 19:57:42",
    "deleted_at": null,
    "recipients": [
      {
        "id": "756c3e48-a15a-4a9b-90c3-dbd97fef5274",
        "user_id": "f68d975c-00c4-4eb0-b9d2-2d2a6306265d",
        "email": "test@example.com",
        "can_reply_send": true,
        "should_encrypt": false,
        "fingerprint": "B8B58C259795FE02485B9A633E794F5F9FDDB0A8",
        "email_verified_at": "2021-07-28 16:42:23",
        "created_at": "2021-07-28 16:41:44",
        "updated_at": "2022-02-25 17:30:01"
      },
    ],
  };

  static const invalidAliasJson = <String, dynamic>{
    "data": {
      "id": "error",
      "user_id": "f68d975c-00c4-4eb0-b9d2-2d2a6306265d",
      "aliasable_id": null,
      "aliasable_type": null,
      "local_part": "pox.tribute734",
      "extension": null,
      "domain": "laylow.io",
      "email": "pox.tribute734@laylow.io",
      "active": true,
      "description": null,
      "emails_forwarded": 0,
      "emails_blocked": 0,
      "emails_replied": 0,
      "emails_sent": 0,
      "created_at": "2022-02-22 18:08:15",
      "updated_at": "2022-03-05 19:57:42",
      "deleted_at": null,
      "recipients": [
        {
          "id": "756c3e48-a15a-4a9b-90c3-dbd97fef5274",
          "user_id": "f68d975c-00c4-4eb0-b9d2-2d2a6306265d",
          "email": "test@example.com",
          "can_reply_send": true,
          "should_encrypt": false,
          "fingerprint": "B8B58C259795FE02485B9A633E794F5F9FDDB0A8",
          "email_verified_at": "2021-07-28 16:42:23",
          "created_at": "2021-07-28 16:41:44",
          "updated_at": "2022-02-25 17:30:01"
        },
      ],
    },
  };
}
