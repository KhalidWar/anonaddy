import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mockito/mockito.dart';

class MockIoClient extends Mock implements IOClient {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return http.Response('body', 200);
  }
}
