
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_config.dart';
import '../models/product.dart';

class ProductService {
  static const Duration _timeout = Duration(seconds: 10);

  // Mengambil semua produk
  static Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/products.php',
    );

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Status HTTP ${response.statusCode} saat mengambil produk.',
      );
    }

    final json = jsonDecode(response.body);

    if (json is! Map<String, dynamic>) {
      throw const FormatException(
        'Respons daftar produk bukan objek JSON.',
      );
    }

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Gagal mengambil daftar produk.',
      );
    }

    final data = json['data'];
    final items = data is Map<String, dynamic>
        ? data['items']
        : data;

    if (items is! List) {
      throw const FormatException(
        'Daftar produk tidak ditemukan dalam respons API.',
      );
    }

    return items.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Format item produk tidak sesuai.',
        );
      }

      return Product.fromJson(item);
    }).toList();
  }

  // Mengambil detail produk berdasarkan ID
  static Future<Product> fetchProductById(int id) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/products.php',
    ).replace(
      queryParameters: {'id': id.toString()},
    );

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Status HTTP ${response.statusCode} '
        'saat mengambil detail produk.',
      );
    }

    final json = jsonDecode(response.body);

    if (json is! Map<String, dynamic>) {
      throw const FormatException(
        'Respons detail produk bukan objek JSON.',
      );
    }

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Gagal mengambil detail produk.',
      );
    }

    final data = json['data'];

    if (data is! Map<String, dynamic> ||
        !data.containsKey('id')) {
      throw const FormatException(
        'Detail produk tidak ditemukan dalam respons API.',
      );
    }

    return Product.fromJson(data);
  }

  // Memeriksa koneksi server
  static Future<String> checkHealth() async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/index.php',
    );

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Status HTTP ${response.statusCode} '
        'saat mengecek koneksi.',
      );
    }

    return 'Server API merespons dengan baik (HTTP 200).';
  }
}
