
import 'package:flutter/material.dart';

import 'models/ringkasan_pesanan.dart';

class PesananBerhasilPage extends StatelessWidget {
  final RingkasanPesanan ringkasan;

  const PesananBerhasilPage({super.key, required this.ringkasan});

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pesanan Diterima'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 96,
                  color: scheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Data pesanan valid',
                  style: text.headlineSmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _baris('Produk', ringkasan.namaProduk),
                        _baris('Harga', ringkasan.harga),
                        _baris('Pembeli', ringkasan.namaPembeli),
                        _baris('Email', ringkasan.email),
                        _baris('Alamat', ringkasan.alamat),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.storefront),
                    label: const Text('Kembali Belanja'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
