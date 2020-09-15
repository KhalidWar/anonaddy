import 'package:anonaddy/provider/api_data_manager.dart';
import 'package:anonaddy/screens/home_screen.dart';
import 'package:anonaddy/utilities/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<APIDataManager>(
      create: (_) => APIDataManager(),
      child: MaterialApp(
        title: 'AnonAddy',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: HomeScreen(),
      ),
    );
  }
}
