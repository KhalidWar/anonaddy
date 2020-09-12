import 'dart:convert';

import 'package:anonaddy/confidential.dart';
import 'package:http/http.dart' as http;

class Networking {
  Networking(this.url);

  final String url;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Authorization": "Bearer $bearerToken",
    "Accept": "application/json",
  };

  Future getData() async {
    http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future postData({String description}) async {
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: headers,
      body: json.encode({
        "domain": "anonaddy.me",
        "format": "uuid",
        "description": "$description",
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.statusCode);
    }
  }

  Future toggleAliasActive() async {
    http.Response response = await http.delete(
      Uri.encodeFull(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
