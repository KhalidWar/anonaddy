import 'dart:convert';

import 'package:anonaddy/utilities/confidential.dart';
import 'package:http/http.dart' as http;

class Networking {
  Networking(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.statusCode);
    }
  }
}
