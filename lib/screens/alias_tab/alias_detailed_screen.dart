import 'package:anonaddy/models/alias_data_model.dart';
import 'package:flutter/material.dart';

class AliasDetailScreen extends StatefulWidget {
  const AliasDetailScreen({Key key, this.aliasData}) : super(key: key);

  final AliasDataModel aliasData;

  @override
  _AliasDetailScreenState createState() => _AliasDetailScreenState();
}

class _AliasDetailScreenState extends State<AliasDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Container(),
    );
  }
}
