
import 'dart:async';

import 'package:flutter/material.dart';

import 'models/product.dart';
import 'routes/app_routes.dart';
import 'services/product_service.dart';

class DetailProdukPage extends StatefulWidget {
  final int id;

  const DetailProdukPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  late Future<Product> _produkFuture;

  @override
  void initState() {
    super.initState();
    _produkFuture = ProductService.fetchProductById(widget.id);
  }

  Future<void> _muatUlang() async {
    final futureBaru = ProductService.fetchProductById(widget.id);

    setState(() {
      _produkFuture = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder.
    }
  }

  Future<void> _bukaCheckout(
    BuildContext context,
    Product product,
  ) async {
    final hasil = await Navigator.pushNamed(
      context,
      AppRoutes.checkout,
      arguments: CheckoutArgs(
        namaProduk: product.title,
        harga: product.hargaRupiah,
        kategori: product.category,
      ),
    );

    if (!context.mounted) return;

    if (hasil == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout dibatalkan, data tidak dikirim.'),
        ),
      );
    }
  }

  Widget _buildError(Object error) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    String pesan = error.toString();

    if (error is TimeoutException) {
      pesan = 'Server terlalu lama memberikan respons.';
    } else if (error is FormatException) {
      pesan = 'Format data produk dari server tidak sesuai.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: scheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Detail produk gagal dimuat',
              textAlign: TextAlign.center,
              style: text.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: text.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(Product product) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              product.thumbnail,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 240,
                  width: double.infinity,
                  color: scheme.surfaceContainerHighest,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Text(
            product.title,
            style: text.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            product.hargaRupiah,
            style: text.titleLarge?.copyWith(
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Kategori: ${product.category}',
            style: text.bodyMedium,
          ),
          Text(
            'Stok: ${product.stock}',
            style: text.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            product.description,
            style: text.bodyMedium,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _bukaCheckout(context, product),
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Lanjut ke Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: FutureBuilder<Product>(
        future: _produkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error!);
          }

          final product = snapshot.data;

          if (product == null) {
            return const Center(
              child: Text('Data produk tidak ditemukan.'),
            );
          }

          return _buildDetail(product);
        },
      ),
    );
  }
}
