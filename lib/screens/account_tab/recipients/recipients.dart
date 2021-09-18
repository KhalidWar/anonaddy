import 'package:anonaddy/global_providers.dart';
import 'package:anonaddy/shared_components/list_tiles/recipient_list_tile.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/shared_components/shimmer_effects/recipients_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Recipients extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recipientStream = watch(recipientsProvider);

    final size = MediaQuery.of(context).size;

    return recipientStream.when(
      loading: () => RecipientsShimmerLoading(),
      data: (data) {
        final recipientList = data.recipients;
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
              return RecipientListTile(
                recipient: recipientList[index],
              );
            },
          );
      },
      error: (error, stackTrace) {
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          lottieHeight: size.height * 0.1,
          label: error.toString(),
        );
      },
    );
  }
}
