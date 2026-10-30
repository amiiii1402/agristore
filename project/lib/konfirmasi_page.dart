import 'package:flutter/material.dart';

class KonfirmasiPage extends StatelessWidget {
  final String namaProduk;
  final String harga;
  final String kategori;
  final String namaPembeli;
  final String email;
  final String nomorTelepon;
  final String alamat;

  const KonfirmasiPage({
    super.key,
    required this.namaProduk,
    required this.harga,
    required this.kategori,
    required this.namaPembeli,
    required this.email,
    required this.nomorTelepon,
    required this.alamat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: const Text('Konfirmasi Pesanan'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Color(0xFF2E7D32),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Center(
                      child: Text(
                        'Pesanan Berhasil!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Center(
                      child: Text(
                        'Data pesanan kamu berhasil '
                        'divalidasi.',
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Divider(height: 32),

                    const Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _barisData('Produk', namaProduk),
                    _barisData('Harga', harga),
                    _barisData('Kategori', kategori),

                    const Divider(height: 28),

                    const Text(
                      'Data Pembeli',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _barisData('Nama', namaPembeli),
                    _barisData('Email', email),
                    _barisData('Nomor Telepon', nomorTelepon),
                    _barisData('Alamat', alamat),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Kembali ke Beranda'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _barisData(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              judul,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(isi)),
        ],
      ),
    );
  }
}
