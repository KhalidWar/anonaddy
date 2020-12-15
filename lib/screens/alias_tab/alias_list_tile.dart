import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';

class AliasListTile extends StatefulWidget {
  const AliasListTile({Key key, this.aliasData}) : super(key: key);

  final AliasDataModel aliasData;

  @override
  _AliasListTileState createState() => _AliasListTileState();
}

class _AliasListTileState extends State<AliasListTile> {
  bool _isLoading = false;

  bool _isDeleted() {
    if (widget.aliasData.deletedAt == null) {
      return false;
    } else {
      return true;
    }
  }

  void _copyOnTab() {
    Clipboard.setData(ClipboardData(text: widget.aliasData.email));
    Fluttertoast.showToast(
      msg: kEmailCopied,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[600],
    );
  }

  void _toggleAliases() async {
    final _apiService = context.read(apiServiceProvider);
    setState(() => _isLoading = true);

    if (widget.aliasData.isAliasActive == true) {
      dynamic deactivateResult =
          await _apiService.deactivateAlias(aliasID: widget.aliasData.aliasID);
      if (deactivateResult == null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          widget.aliasData.isAliasActive = false;
          _isLoading = false;
        });
      }
    } else {
      dynamic activateResult =
          await _apiService.activateAlias(aliasID: widget.aliasData.aliasID);
      if (activateResult == null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          widget.aliasData.isAliasActive = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      dense: true,
      title: Text(
        '${widget.aliasData.email}',
        style: TextStyle(color: _isDeleted() ? Colors.grey : Colors.black),
      ),
      subtitle: Text(
        '${widget.aliasData.emailDescription}',
        style: TextStyle(color: Colors.grey),
      ),
      leading: _isLoading
          ? Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: CircularProgressIndicator())
          : Switch(
              value: widget.aliasData.isAliasActive,
              onChanged: _isDeleted() ? null : (toggle) => _toggleAliases(),
            ),
      trailing: IconButton(
        icon: Icon(Icons.copy),
        onPressed: _isDeleted() ? null : () => _copyOnTab(),
      ),
    );
  }
}
