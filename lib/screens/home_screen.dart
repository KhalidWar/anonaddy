import 'package:anonaddy/screens/search_tab/search_tab.dart';
import 'package:anonaddy/screens/settings_screen/settings_screen.dart';
import 'package:anonaddy/services/connectivity/connectivity_service.dart';
import 'package:anonaddy/services/data_storage/search_history_storage.dart';
import 'package:anonaddy/shared_components/constants/material_constants.dart';
import 'package:anonaddy/shared_components/constants/ui_strings.dart';
import 'package:anonaddy/shared_components/custom_page_route.dart';
import 'package:anonaddy/shared_components/no_internet_alert.dart';
import 'package:anonaddy/state_management/providers/class_providers.dart';
import 'package:anonaddy/state_management/providers/global_providers.dart';
import 'package:anonaddy/utilities/niche_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'account_tab/account_tab.dart';
import 'alias_tab/alias_tab.dart';
import 'alias_tab/create_new_alias/create_new_alias.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  void _selectedTab(int index) {
    if (_selectedIndex == 2 && index == 2) {
      SearchTab().search(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void checkIfAppUpdated() async {
    final changeLog = context.read(changelogServiceProvider);
    await changeLog.checkIfAppUpdated(context).whenComplete(() async {
      await changeLog.isAppUpdated().then((value) {
        if (value) buildUpdateNews(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkIfAppUpdated();
    SearchHistoryStorage().openSearchHiveBox();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer(
      builder: (_, watch, __) {
        final connectivityAsyncValue = watch(connectivityStreamProvider);
        bool isOffline = false;

        connectivityAsyncValue.whenData((data) {
          if (data == ConnectionStatus.offline) {
            isOffline = true;
          } else {
            isOffline = false;
          }
        });
        return Scaffold(
          appBar: buildAppBar(context, isOffline),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              AccountTab(),
              AliasTab(),
              SearchTab(),
            ],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isOffline ? NoInternetAlert() : Container(),
              BottomNavigationBar(
                onTap: _selectedTab,
                currentIndex: _selectedIndex,
                selectedItemColor: isDark ? kAccentColor : kPrimaryColor,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: kAccountBotNavLabel,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.alternate_email_sharp),
                    label: kAliasesBotNavLabel,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined),
                    label: kSearchBotNavLabel,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context, bool isOffline) {
    final showToast = NicheMethod().showToast;

    return AppBar(
      elevation: 0,
      title: const Text(kAppBarTitle, style: TextStyle(color: Colors.white)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.add_circle_outline_outlined),
        onPressed: isOffline
            ? () => showToast(kCreateAliasWhileOffline)
            : () {
                final userModel = context.read(accountStreamProvider).data;
                if (userModel == null) {
                  showToast(kLoadingText);
                } else {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(kBottomSheetBorderRadius)),
                    ),
                    builder: (context) => CreateNewAlias(),
                  );
                }
              },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () =>
              Navigator.push(context, CustomPageRoute(SettingsScreen())),
        ),
      ],
    );
  }

  Future buildUpdateNews(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (context) {
        return Container(
          height: size.height * 0.5,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s new?',
                style: Theme.of(context).textTheme.headline6,
              ),
              Consumer(
                builder: (_, watch, __) {
                  final appInfo = watch(packageInfoProvider);
                  return appInfo.when(
                    data: (data) => Text('Version: ${data.version}'),
                    loading: () => CircularProgressIndicator(),
                    error: (error, stackTrace) => Text(error.toString()),
                  );
                },
              ),
              Divider(height: size.height * 0.05),
              //todo automate changelog fetching
              Text(
                  '1. Improved background services which should eliminate "too many requests" error'),
              SizedBox(height: size.height * 0.01),
              Text(
                  '2. Improved initial loading times by loading data from disk'),
              SizedBox(height: size.height * 0.01),
              Text('3. Fixed Create New Alias bug on app start'),
              SizedBox(height: size.height * 0.01),
              Text('4. Added error indicator to Alias Domain and Alias Format'),
              SizedBox(height: size.height * 0.01),
              Text('5. Several UI improvements'),
              SizedBox(height: size.height * 0.01),
              Text('6. Several under the hood improvements'),
              SizedBox(height: size.height * 0.01),
              Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  child: Text('Continue to AddyManager'),
                  onPressed: () {
                    context.read(changelogServiceProvider).dismissChangeLog();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
