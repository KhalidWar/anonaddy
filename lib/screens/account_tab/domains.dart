import 'package:anonaddy/shared_components/constants/toast_messages.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Domains extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final account = watch(accountStreamProvider).data;
    if (account == null) {
      return LottieWidget(
        lottie: 'assets/lottie/errorCone.json',
        lottieHeight: MediaQuery.of(context).size.height * 0.2,
        label: kFailedLoadAccountData,
      );
    } else {
      return Center(
        child: Text(
          account.value.subscription == 'free'
              ? kOnlyAvailableToPaid
              : kComingSoon,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }

    // final domainsStream = watch(domainsStreamProvider);
    // return domainsStream.when(
    //   loading: () => RecipientsShimmerLoading(),
    //   data: (data) {
    //     if (data.domainDataList.isEmpty)
    //       return Center(
    //         child: Text('No domains found',
    //             style: Theme.of(context).textTheme.bodyText1),
    //       );
    //     else
    //       return ListView.builder(
    //         shrinkWrap: true,
    //         itemCount: data.domainDataList.length,
    //         itemBuilder: (context, index) {
    //           final domain = data.domainDataList[index];
    //
    //           return InkWell(
    //             child: Padding(
    //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Icon(
    //                     Icons.account_circle_outlined,
    //                     // color: isDark ? Colors.white : Colors.grey,
    //                     size: 30,
    //                   ),
    //                   SizedBox(width: 15),
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text('${domain.domain}'),
    //                       SizedBox(height: 2),
    //                       Text(
    //                         '${domain.description}',
    //                         style: TextStyle(color: Colors.grey),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 PageRouteBuilder(
    //                   transitionsBuilder:
    //                       (context, animation, secondAnimation, child) {
    //                     animation = CurvedAnimation(
    //                         parent: animation, curve: Curves.linearToEaseOut);
    //
    //                     return SlideTransition(
    //                       position: Tween(
    //                         begin: Offset(1.0, 0.0),
    //                         end: Offset(0.0, 0.0),
    //                       ).animate(animation),
    //                       child: child,
    //                     );
    //                   },
    //                   pageBuilder: (context, animation, secondAnimation) {
    //                     return Container();
    //                     // return UsernameDetailedScreen(username: username);
    //                   },
    //                 ),
    //               );
    //             },
    //           );
    //         },
    //       );
    //   },
    //   error: ((error, stackTrace) {
    //     return LottieWidget(
    //       lottie: 'assets/lottie/errorCone.json',
    //       lottieHeight: MediaQuery.of(context).size.height * 0.1,
    //       label: error.toString(),
    //     );
    //   }),
    // );
  }
}
