
import 'package:http/http.dart' as http;
class HttpClient {
  HttpClient({required this.baseUrl, http.Client? client})
  : _client = client ?? http.Client();
  final String baseUrl;
  final http.Client _client;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<http.Response> post (
      String path, {
        Map<String, String>? headers,
        Object? body,
        Duration timeout = const Duration(seconds: 10);

  }
      ) {
    
  }
}