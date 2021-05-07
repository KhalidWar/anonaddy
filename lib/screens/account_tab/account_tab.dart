import 'package:anonaddy/screens/account_tab/domains.dart';
import 'package:anonaddy/screens/account_tab/recipients.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/loading_indicator.dart';
import 'package:anonaddy/shared_components/lottie_widget.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'additional_username.dart';
import 'main_account.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: size.height * 0.38,
                elevation: 0,
                floating: true,
                pinned: true,
                backgroundColor: isDark ? Colors.black : Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Consumer(
                    builder: (_, watch, __) {
                      final accountStream = watch(accountStreamProvider);
                      return accountStream.when(
                        loading: () => LoadingIndicator(),
                        data: (data) => MainAccount(userModel: data),
                        error: (error, stackTrace) {
                          return LottieWidget(
                            showLoading: true,
                            lottie: 'assets/lottie/errorCone.json',
                            lottieHeight: size.height * 0.1,
                            label: error.toString(),
                          );
                        },
                      );
                    },
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: kAccentColor,
                  labelColor: isDark ? Colors.white : Colors.black,
                  tabs: [
                    Tab(child: Text('Recipients')),
                    Tab(child: Text('Usernames')),
                    Tab(child: Text('Domains')),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Recipients(),
              AdditionalUsername(),
              Domains(),
            ],
          ),
        ),
      ),
    );
  }
}
