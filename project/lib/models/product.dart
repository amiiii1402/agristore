class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _toInt(json['id']),
      title: _toText(json['name'] ?? json['title'], 'Tanpa nama'),
      description: _toText(json['description'], '-'),
      category: _toText(json['category'], '-'),
      price: _toDouble(json['price']),
      rating: _toDouble(json['rating']),
      stock: _toInt(json['stock']),
      thumbnail: _toText(json['image_url'] ?? json['thumbnail'], ''),
    );
  }

  String get hargaRupiah {
    final angka = price.toStringAsFixed(0);
    final hasil = angka.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $hasil';
  }

  static String _toText(dynamic value, String fallback) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
