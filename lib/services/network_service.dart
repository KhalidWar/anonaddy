import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  const NetworkService({@required this.url, @required this.accessToken});

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
      print('Network getData ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Network getData ${response.statusCode}');
      return null;
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
      print('Network postData ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Network postData ${response.statusCode}');
      throw Exception('Failed to postData in Network');
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
      print('Network activateAlias ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Network activateAlias ${response.statusCode}');
      return null;
    }
  }

  Future deactivateAlias() async {
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
      print('Network deactivateAlias ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Network deactivateAlias ${response.statusCode}');
      return null;
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
      print('Network editDescription ${response.statusCode}');
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
      print('Network deleteAlias ${response.statusCode}');
      print(response.statusCode);
    } else if (response.statusCode == 204) {
      print(response.statusCode);
      // throw Exception('Failed to deleteAlias');
    }
  }
}
