import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Networking {
  Networking({@required this.url, @required this.accessToken});

  final String url, accessToken;

  Future getData() async {
    http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      print('Networking getData ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Networking getData ${response.statusCode}');
      throw Exception('Failed to getData in Networking');
    }
  }

  Future postData({String description}) async {
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
      body: json.encode({
        "domain": "anonaddy.me",
        "format": "uuid",
        "description": "$description",
      }),
    );
    if (response.statusCode == 201) {
      print('Networking postData ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Networking postData ${response.statusCode}');
      throw Exception('Failed to postData in Networking');
    }
  }

  Future activateAlias({String aliasID}) async {
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
      body: json.encode({"id": "$aliasID"}),
    );
    if (response.statusCode == 200) {
      print('Networking activateAlias ${response.statusCode}');
    } else {
      print('Networking activateAlias ${response.statusCode}');
    }
  }

  Future deactivateAlias() async {
    http.Response response = await http.delete(Uri.encodeFull(url), headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      print('Networking deactivateAlias ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Networking deactivateAlias ${response.statusCode}');
      // throw Exception('Failed to deactivateAlias in Networking');
    }
  }

  Future editDescription({String newDescription}) async {
    http.Response response = await http.patch(Uri.encodeFull(url),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "description": "$newDescription",
        }));
    if (response.statusCode == 200) {
      print('Networking editDescription ${response.statusCode}');
    } else {
      return (response.statusCode);
    }
  }

  Future deleteAlias() async {
    http.Response response = await http.delete(
      Uri.encodeFull(url),
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      print('Networking deleteAlias ${response.statusCode}');
      print(response.statusCode);
    } else if (response.statusCode == 204) {
      print(response.statusCode);
      // throw Exception('Failed to deleteAlias');
    }
  }
}
