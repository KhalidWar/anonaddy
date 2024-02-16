class FailedDeliveriesTestData {
  static const validFailedDeliveriesJson = <String, dynamic>{
    "data": [
      {
        "id": "0222b9fe-59d0-4066-a711-c44ad42f1734",
        "user_id": "ca0a4e09-c266-4f6f-845c-958db5090f09",
        "recipient_id": "46eebc50-f7f8-46d7-beb9-c37f04c29a84",
        "recipient_email": "user@recipient.com",
        "alias_id": "50c9e585-e7f5-41c4-9016-9014c15454bc",
        "alias_email": "alias@anonaddy.com",
        "bounce_type": "spam",
        "remote_mta": "mail.icloud.com",
        "sender": "sender@example.com",
        "email_type": "F",
        "status": "5.7.1",
        "code":
            "smtp; 554 5.7.1 [CS01] Message rejected due to local policy. Please visit https://support.apple.com/en-us/HT204137",
        "attempted_at": "2019-10-01 09:00:00",
        "created_at": "2019-10-01 09:00:00",
        "updated_at": "2019-10-01 09:00:00"
      },
      {
        "id": "f6d1cfe6-46b6-4068-5881-b7cd07dac8a2",
        "user_id": "ca0a4e09-c266-4f6f-845c-958db5090f09",
        "recipient_id": "46eebc50-f7f8-46d7-beb9-c37f04c29a84",
        "recipient_email": "user@recipient.com",
        "alias_id": "50c9e585-e7f5-41c4-9016-9014c15454bc",
        "alias_email": "alias@anonaddy.com",
        "bounce_type": "hard",
        "remote_mta": "mail.example.com",
        "sender": "sender@example.com",
        "email_type": "F",
        "status": "5.7.1",
        "code":
            "smtp; 550 5.7.1 <does-not-exist@example.com>: Recipient address rejected: Recipient not found",
        "attempted_at": "2019-10-01 09:00:00",
        "created_at": "2019-10-01 09:00:00",
        "updated_at": "2019-10-01 09:00:00"
      }
    ]
  };
}
