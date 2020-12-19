import 'package:anonaddy/screens/account_tab/main_account_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'additional_username_card.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context
          .refresh(mainAccountStream)
          .then((value) => context.refresh(additionalUsernameFuture)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MainAccount(),
            AdditionalUsernameCard(),
          ],
        ),
      ),
    );
  }
}
