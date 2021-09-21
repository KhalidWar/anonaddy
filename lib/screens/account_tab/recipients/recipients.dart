import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:anonaddy/state_management/recipient/recipient_notifier.dart';
import 'package:anonaddy/state_management/recipient/recipient_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Recipients extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recipientState = watch(recipientStateNotifier);

    final size = MediaQuery.of(context).size;

    switch (recipientState.status) {
      case RecipientStatus.loading:
        return RecipientsShimmerLoading();

      case RecipientStatus.loaded:
        final recipientList = recipientState.recipientModel!.recipients;
        if (recipientList.isEmpty)
          return Center(
            child: Text('No recipients found',
                style: Theme.of(context).textTheme.bodyText1),
          );
        else
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: size.height * 0.004),
            itemCount: recipientList.length,
            itemBuilder: (context, index) {
              return RecipientListTile(recipient: recipientList[index]);
            },
          );

      case RecipientStatus.failed:
        final error = recipientState.errorMessage;
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          lottieHeight: size.height * 0.1,
          label: error.toString(),
        );
    }
  }
}
