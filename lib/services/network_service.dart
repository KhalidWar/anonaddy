import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkService {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Accept": "application/json",
  };

  Future getData({String url, String accessToken}) async {
    headers["Authorization"] = "Bearer $accessToken";
    http.Response response = await http.get(
      Uri.encodeFull(url),
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('Network getData ${response.statusCode}');
      return jsonDecode(response.body);
    } else {
      print('Network getData ${response.statusCode}');
      return null;
    }
  }

  Future postData({String description, String url, String accessToken}) async {
    headers["Authorization"] = "Bearer $accessToken";
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: headers,
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
      return null;
    }
  }

  Future activateAlias({String aliasID, String url, String accessToken}) async {
    headers["Authorization"] = "Bearer $accessToken";
    http.Response response = await http.post(
      Uri.encodeFull(url),
      headers: headers,
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

  Future deactivateAlias({String url, String accessToken}) async {
    headers["Authorization"] = "Bearer $accessToken";
    http.Response response = await http.delete(
      Uri.encodeFull(url),
      headers: headers,
    );
    if (response.statusCode == 204) {
      print('Network deactivateAlias ${response.statusCode}');
      return response.body;
    } else {
      print('Network deactivateAlias ${response.statusCode}');
      return null;
    }
  }

  Future editDescription(
      {String newDescription, String url, String accessToken}) async {
    headers["Authorization"] = "Bearer $accessToken";
    http.Response response = await http.patch(Uri.encodeFull(url),
        headers: headers,
        body: jsonEncode({
          "description": "$newDescription",
        }));
    if (response.statusCode == 200) {
      print('Network editDescription ${response.statusCode}');
      return response.body;
    } else {
      print('Network editDescription ${response.statusCode}');
      return null;
    }
  }

  Future deleteAlias({String url, String accessToken}) async {
    headers["Authorization"] = "Bearer $accessToken";
    http.Response response = await http.delete(
      Uri.encodeFull(url),
      headers: headers,
    );
    if (response.statusCode == 204) {
      print('Network deleteAlias ${response.statusCode}');
      return response.body;
    } else {
      print('Network deleteAlias ${response.statusCode}');
      return null;
    }
  }
}
