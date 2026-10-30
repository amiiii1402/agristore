
import 'package:flutter/material.dart';

import 'models/ringkasan_pesanan.dart';
import 'routes/app_routes.dart';

class CheckoutPage extends StatefulWidget {
  final String namaProduk;
  final String harga;
  final String kategori;

  const CheckoutPage({
    super.key,
    required this.namaProduk,
    required this.harga,
    required this.kategori,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final formKey = GlobalKey<FormState>();

  String namaPembeli = '';
  String email = '';
  String alamat = '';
  String nomorTelepon = '';

  bool _adaPerubahan = false;

  void submitForm() {
    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.pesananBerhasil,
      ModalRoute.withName(AppRoutes.home),
      arguments: RingkasanPesanan(
        namaProduk: widget.namaProduk,
        harga: widget.harga,
        namaPembeli: namaPembeli,
        email: email,
        alamat: alamat,
      ),
    );
  }

  Future<bool> _konfirmasiKeluar() async {
    final keluar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan checkout?'),
        content: const Text('Data yang sudah diisi akan hilang.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Lanjut mengisi'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Batalkan'),
          ),
        ],
      ),
    );

    return keluar ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopScope<Object?>(
      canPop: !_adaPerubahan,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final keluar = await _konfirmasiKeluar();

        if (keluar && mounted) {
          Navigator.pop(context, false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout AgriStore'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            onChanged: () {
              if (!_adaPerubahan) {
                setState(() {
                  _adaPerubahan = true;
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_bag_outlined,
                      color: scheme.primary,
                    ),
                    title: Text(widget.namaProduk),
                    subtitle: Text(
                      '${widget.harga}\n'
                      'Kategori: ${widget.kategori}',
                    ),
                    isThreeLine: true,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nama lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (nilai) {
                    if (nilai == null || nilai.trim().isEmpty) {
                      return 'Nama lengkap harus diisi';
                    }
                    return null;
                  },
                  onSaved: (nilai) {
                    namaPembeli = nilai!.trim();
                  },
                ),
                const SizedBox(height: 14),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (nilai) {
                    final teks = nilai?.trim() ?? '';

                    if (teks.isEmpty) {
                      return 'Email harus diisi';
                    }

                    if (!teks.contains('@')) {
                      return 'Format email belum benar';
                    }

                    return null;
                  },
                  onSaved: (nilai) {
                    email = nilai!.trim();
                  },
                ),
                const SizedBox(height: 14),

                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor telepon',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (nilai) {
                    final teks = nilai?.trim() ?? '';

                    if (teks.isEmpty) {
                      return 'Nomor telepon harus diisi';
                    }

                    final angka = teks.replaceAll(RegExp(r'\D'), '');

                    if (angka.length < 10) {
                      return 'Nomor telepon minimal 10 digit';
                    }

                    return null;
                  },
                  onSaved: (nilai) {
                    nomorTelepon = nilai!.trim();
                  },
                ),
                const SizedBox(height: 14),

                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Alamat pengiriman',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (nilai) {
                    final teks = nilai?.trim() ?? '';

                    if (teks.isEmpty) {
                      return 'Alamat harus diisi';
                    }

                    if (teks.length < 10) {
                      return 'Alamat minimal 10 karakter';
                    }

                    return null;
                  },
                  onSaved: (nilai) {
                    alamat = nilai!.trim();
                  },
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          formKey.currentState?.reset();

                          setState(() {
                            _adaPerubahan = false;
                            namaPembeli = '';
                            email = '';
                            alamat = '';
                            nomorTelepon = '';
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: submitForm,
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
