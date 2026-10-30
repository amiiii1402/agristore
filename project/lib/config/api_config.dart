
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost/agristore-api',
  );

  static const Duration timeout = Duration(seconds: 10);

  static Uri health() {
    return Uri.parse('$baseUrl/index.php');
  }

  static Uri products({int? id}) {
    final uri = Uri.parse('$baseUrl/api/products.php');

    if (id == null) {
      return uri;
    }

    return uri.replace(
      queryParameters: {'id': id.toString()},
    );
  }
}
