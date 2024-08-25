import "package:http/http.dart" as http;

Future<http.Response> requestWithRetry(url,
    {int maxRetries = 3, Map<String, String>? headers}) async {
  for (var i = 0; i < maxRetries; i++) {
    try {
      return headers != null
          ? await http
              .get(Uri.parse(url), headers: headers)
              .timeout(const Duration(seconds: 30))
          : await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
    }
  }
  throw Exception('Failed after $maxRetries retries');
}
