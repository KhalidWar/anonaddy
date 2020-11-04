import 'package:anonaddy/models/alias_data_model.dart';
import 'package:anonaddy/models/user_model.dart';
import 'package:anonaddy/screens/error_screen.dart';
import 'package:anonaddy/screens/profile_screen.dart';
import 'package:anonaddy/screens/settings_screen.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:anonaddy/widgets/account_card.dart';
import 'package:anonaddy/widgets/alias_card.dart';
import 'package:anonaddy/widgets/create_new_alias.dart';
import 'package:anonaddy/widgets/loading_widget.dart';
import 'package:anonaddy/widgets/pop_scope_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final APIService _apiService = APIService();

  Stream<UserModel> userModelStream;

  Future<bool> _onBackButtonPress() {
    return showDialog(
        context: context,
        builder: (context) {
          return PopScopeDialog();
        });
  }

  @override
  void initState() {
    super.initState();
    userModelStream = _apiService.getUserDataStream();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: buildAppBar(),
        floatingActionButton: buildFloatingActionButton(context),
        body: WillPopScope(
          onWillPop: _onBackButtonPress,
          child: StreamBuilder<UserModel>(
              stream: userModelStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return ErrorScreen(
                        label:
                            'No Internet Connection. \n Make sure you\'re online.',
                        buttonLabel: 'Reload',
                        buttonOnPress: () {});
                    break;
                  case ConnectionState.waiting:
                    return LoadingWidget();
                  default:
                    if (snapshot.hasData) {
                      for (var item in snapshot.data.aliasDataList) {
                        UserModel(
                          aliasDataList: [
                            AliasDataModel(
                              aliasID: item.aliasID,
                              email: item.email,
                              emailDescription: item.emailDescription,
                              createdAt: item.createdAt,
                              isAliasActive: item.isAliasActive,
                            ),
                          ],
                        );
                      }
                      return SingleChildScrollView(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            AccountCard(userData: snapshot.data),
                            AliasCard(
                              apiService: _apiService,
                              aliasDataList: snapshot.data.aliasDataList,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return ErrorScreen(
                          label: '${snapshot.error}',
                          buttonLabel: 'Sign In',
                          buttonOnPress: () {});
                    }
                    return LoadingWidget();
                }
              }),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: SvgPicture.asset(
        'assets/images/logo.svg',
        height: MediaQuery.of(context).size.height * 0.03,
      ),
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }),
      actions: [
        IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            }),
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return CreateNewAlias(apiService: _apiService);
            });
      },
    );
  }
}
