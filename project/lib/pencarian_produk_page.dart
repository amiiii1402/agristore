import 'package:flutter/material.dart';

class PencarianProdukPage extends StatefulWidget {
  const PencarianProdukPage({super.key});

  @override
  State<PencarianProdukPage> createState() =>
      _PencarianProdukPageState();
}

class _PencarianProdukPageState
    extends State<PencarianProdukPage> {
  String? _kategoriDipilih;

  final List<String> _kategori = [
    'Semua',
    'Sayuran',
    'Bibit',
    'Pupuk',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Produk'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih kategori produk',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._kategori.map(
              (kategori) => RadioListTile<String>(
                title: Text(kategori),
                value: kategori,
                groupValue: _kategoriDipilih,
                onChanged: (value) {
                  setState(() {
                    _kategoriDipilih = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _kategoriDipilih == null
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                          _kategoriDipilih,
                        );
                      },
                icon: const Icon(Icons.check),
                label: const Text('Terapkan Kategori'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
