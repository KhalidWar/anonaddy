import 'package:anonaddy/models/alias/alias_data_model.dart';
import 'package:anonaddy/state_management/alias_state_manager.dart';
import 'package:anonaddy/state_management/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AliasListTile extends StatefulWidget {
  const AliasListTile({Key key, this.aliasData}) : super(key: key);
  final AliasDataModel aliasData;

  @override
  _AliasListTileState createState() => _AliasListTileState();
}

class _AliasListTileState extends State<AliasListTile> {
  bool _isLoading = false;
  bool _switchValue;

  void toggleAlias() async {
    final _apiService = context.read(aliasServiceProvider);
    setState(() => _isLoading = true);
    if (widget.aliasData.isAliasActive == true) {
      dynamic deactivateResult =
          await _apiService.deactivateAlias(widget.aliasData.aliasID);
      if (deactivateResult == null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _switchValue = false;
          _isLoading = false;
        });
      }
    } else {
      dynamic activateResult =
          await _apiService.activateAlias(widget.aliasData.aliasID);
      if (activateResult == null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _switchValue = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final aliasState = context.read(aliasStateManagerProvider);
    final copyAlias = aliasState.copyToClipboard;
    final isDeleted = aliasState.isAliasDeleted;

    _switchValue = widget.aliasData.isAliasActive;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      dense: true,
      title: Text(
        '${widget.aliasData.email}',
        style: TextStyle(
            color: isDeleted(widget.aliasData.deletedAt)
                ? Colors.grey
                : Colors.black),
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
              value: _switchValue,
              onChanged: isDeleted(widget.aliasData.deletedAt)
                  ? null
                  : (toggle) => toggleAlias(),
            ),
      trailing: IconButton(
        icon: Icon(Icons.copy),
        onPressed: isDeleted(widget.aliasData.deletedAt)
            ? null
            : () => copyAlias(widget.aliasData.email),
      ),
    );
  }
}
