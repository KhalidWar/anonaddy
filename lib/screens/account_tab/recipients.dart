import 'package:anonaddy/models/recipient/recipient_model.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:anonaddy/widgets/loading_indicator.dart';
import 'package:anonaddy/widgets/lottie_widget.dart';
import 'package:anonaddy/widgets/recipient_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipientStreamProvider =
    FutureProvider.autoDispose<RecipientModel>((ref) {
  final offlineData = ref.read(offlineDataProvider);
  return ref.read(recipientServiceProvider).getAllRecipient(offlineData);
});

class Recipients extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recipientStream = watch(recipientStreamProvider);

    return recipientStream.when(
      loading: () => LoadingIndicator(),
      data: (data) {
        final recipientList = data.recipientDataList;
        if (recipientList.isEmpty)
          return Center(
            child: Text('No recipients found',
                style: Theme.of(context).textTheme.bodyText1),
          );
        else
          return ListView.builder(
            shrinkWrap: true,
            itemCount: recipientList.length,
            itemBuilder: (context, index) {
              return RecipientListTile(
                recipientDataModel: recipientList[index],
              );
            },
          );
      },
      error: (error, stackTrace) {
        return LottieWidget(
          showLoading: true,
          lottie: 'assets/lottie/errorCone.json',
          lottieHeight: MediaQuery.of(context).size.height * 0.1,
          label: '$error',
        );
      },
    );
  }
}
