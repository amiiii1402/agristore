
import 'package:flutter/material.dart';

class FormPesananPage extends StatefulWidget {
  /// Nilai awal jumlah pesanan yang dikirim dari Beranda.
  final int initialJumlah;

  const FormPesananPage({super.key, this.initialJumlah = 1});

  @override
  State<FormPesananPage> createState() => _FormPesananPageState();
}

class _FormPesananPageState extends State<FormPesananPage> {
  final namaController = TextEditingController();
  final catatanController = TextEditingController();
  final alamatController = TextEditingController();

  String? kategori;
  String pembayaran = 'Tunai';
  bool pengirimanCepat = false;
  bool setuju = false;
  bool kemasanRamahLingkungan = false;

  late int jumlah;
  int panjangNama = 0;

  final daftarKategori = <String>[
    'Sayuran',
    'Buah',
    'Bibit',
    'Alat Pertanian',
    'Pupuk',
  ];

  @override
  void initState() {
    super.initState();
    jumlah = widget.initialJumlah;
  }

  @override
  void dispose() {
    namaController.dispose();
    catatanController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  void tambahJumlah() {
    setState(() => jumlah++);
  }

  void kurangJumlah() {
    if (jumlah > 1) {
      setState(() => jumlah--);
    }
  }

  void resetForm() {
    namaController.clear();
    catatanController.clear();
    alamatController.clear();

    setState(() {
      kategori = null;
      pembayaran = 'Tunai';
      pengirimanCepat = false;
      setuju = false;
      kemasanRamahLingkungan = false;
      jumlah = widget.initialJumlah;
      panjangNama = 0;
    });
  }

  void simpanPesanan() {
    final nama = namaController.text.trim();
    final alamat = alamatController.text.trim();

    if (nama.isEmpty || alamat.isEmpty || kategori == null || !setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi nama, alamat, kategori, dan persetujuan.',
          ),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pesanan tersimpan'),
        content: SingleChildScrollView(
          child: Text(
            'Nama: $nama\n'
            'Alamat: $alamat\n'
            'Kategori: $kategori\n'
            'Jumlah: $jumlah\n'
            'Pembayaran: $pembayaran\n'
            'Pengiriman cepat: '
            '${pengirimanCepat ? "Ya" : "Tidak"}\n'
            'Kemasan ramah lingkungan: '
            '${kemasanRamahLingkungan ? "Ya" : "Tidak"}\n'
            'Catatan: ${catatanController.text.isEmpty ? "-" : catatanController.text}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
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
      backgroundColor: scheme.surface,

      // AppBar netral dengan teks yang mengikuti mode terang/gelap.
      appBar: AppBar(
        title: Text(
          'Form Pesanan',
          style: text.titleLarge?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        backgroundColor: scheme.surfaceContainerLow,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: scheme.outlineVariant,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset form',
            onPressed: resetForm,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://png.pngtree.com/png-clipart/20240828/original/pngtree-fresh-vegetables-png-image_15874541.png',
                width: double.infinity,
                height: 165,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 165,
                    color: scheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: scheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.agriculture,
                      size: 52,
                      color: scheme.primary,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pesan Produk Pertanian',
                    style: text.headlineSmall,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/images/buah.jpg',
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 140,
                    color: scheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.eco,
                      size: 48,
                      color: scheme.primary,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: namaController,
              textInputAction: TextInputAction.next,
              onChanged: (nilai) {
                setState(() => panjangNama = nilai.length);
              },
              decoration: InputDecoration(
                labelText: 'Nama pembeli',
                prefixIcon: const Icon(Icons.person_outline),
                helperText: '$panjangNama karakter',
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: alamatController,
              textInputAction: TextInputAction.next,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Alamat lengkap',
                prefixIcon: Icon(Icons.home_outlined),
                helperText: 'Alamat tidak boleh kosong',
              ),
            ),

            const SizedBox(height: 14),

            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Kategori produk',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: kategori,
                  isExpanded: true,
                  hint: const Text('Pilih kategori'),
                  items: daftarKategori.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (nilai) {
                    setState(() => kategori = nilai);
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: catatanController,
              maxLines: 2,
              onSubmitted: (nilai) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Catatan: $nilai')),
                );
              },
              decoration: const InputDecoration(
                labelText: 'Catatan pesanan',
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
            ),

            const SizedBox(height: 18),

            Text('Jumlah produk', style: text.titleMedium),

            Row(
              children: [
                IconButton(
                  tooltip: 'Kurangi',
                  onPressed: kurangJumlah,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$jumlah', style: text.titleLarge),
                IconButton(
                  tooltip: 'Tambah',
                  onPressed: tambahJumlah,
                  icon: Icon(
                    Icons.add_circle,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),

            Text('Metode pembayaran', style: text.titleMedium),

            RadioListTile<String>(
              title: const Text('Tunai'),
              value: 'Tunai',
              groupValue: pembayaran,
              onChanged: (nilai) {
                setState(() => pembayaran = nilai!);
              },
            ),

            RadioListTile<String>(
              title: const Text('Transfer'),
              value: 'Transfer',
              groupValue: pembayaran,
              onChanged: (nilai) {
                setState(() => pembayaran = nilai!);
              },
            ),

            RadioListTile<String>(
              title: const Text('E-Wallet'),
              value: 'E-Wallet',
              groupValue: pembayaran,
              onChanged: (nilai) {
                setState(() => pembayaran = nilai!);
              },
            ),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Pengiriman cepat'),
              value: pengirimanCepat,
              onChanged: (nilai) {
                setState(() => pengirimanCepat = nilai);
              },
            ),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Kemasan ramah lingkungan'),
              value: kemasanRamahLingkungan,
              onChanged: (nilai) {
                setState(() {
                  kemasanRamahLingkungan = nilai ?? false;
                });
              },
            ),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Saya menyetujui data pesanan'),
              value: setuju,
              onChanged: (nilai) {
                setState(() => setuju = nilai ?? false);
              },
            ),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: resetForm,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: simpanPesanan,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Simpan'),
                  ),
                ),
              ],
            ),

            Center(
              child: TextButton(
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'AgriStore',
                    applicationVersion: '1.0',
                  );
                },
                child: const Text('Tentang aplikasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
