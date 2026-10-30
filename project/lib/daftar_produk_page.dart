
import 'package:flutter/material.dart';

import 'models/product.dart';
import 'services/product_service.dart';
import 'routes/app_routes.dart';

class DaftarProdukPage extends StatefulWidget {
  final String kategoriAwal;

  const DaftarProdukPage({
    super.key,
    this.kategoriAwal = 'Semua Produk',
  });

  @override
  State<DaftarProdukPage> createState() => _DaftarProdukPageState();
}

class _DaftarProdukPageState extends State<DaftarProdukPage>
    with SingleTickerProviderStateMixin {
  static const List<String> _kategori = [
    'Semua Produk',
    'Sayuran',
    'Buah',
    'Bibit',
    'Alat',
    'Pupuk',
  ];

  static const List<IconData> _ikonKategori = [
    Icons.storefront_outlined,
    Icons.eco_outlined,
    Icons.apple,
    Icons.grass,
    Icons.handyman_outlined,
    Icons.compost,
  ];

  late TabController _tabController;
  late Future<List<Product>> _produkFuture;

  String _kategoriAktif = 'Semua Produk';
  final TextEditingController _cariController = TextEditingController();

  String _kataKunci = '';
  bool _stokTersediaSaja = false;
  bool _hargaTermurah = false;
  bool _sedangMemuatUlang = false;

  DateTime? _terakhirDiperbarui;

  @override
  void initState() {
    super.initState();

    final indexAwal = _kategori.indexOf(widget.kategoriAwal);
    final indexTerpilih = indexAwal < 0 ? 0 : indexAwal;

    _tabController = TabController(
      length: _kategori.length,
      vsync: this,
      initialIndex: indexTerpilih,
    );

    _kategoriAktif = _kategori[indexTerpilih];
    _tabController.addListener(_perbaruiTampilan);

    _produkFuture = _ambilProduk();
  }

  Future<List<Product>> _ambilProduk() async {
    final hasil = await ProductService.fetchProducts();

    if (mounted) {
      setState(() {
        _terakhirDiperbarui = DateTime.now();
      });
    }

    return hasil;
  }

  void _perbaruiTampilan() {
    if (!mounted) return;

    setState(() {
      _kategoriAktif = _kategori[_tabController.index];
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_perbaruiTampilan);
    _tabController.dispose();
    _cariController.dispose();
    super.dispose();
  }

  Future<void> _muatUlang() async {
    if (_sedangMemuatUlang) return;

    setState(() {
      _sedangMemuatUlang = true;
    });

    final futureBaru = _ambilProduk();

    setState(() {
      _produkFuture = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Error ditampilkan melalui FutureBuilder.
    } finally {
      if (mounted) {
        setState(() {
          _sedangMemuatUlang = false;
        });
      }
    }
  }

  bool _sesuaiKategori(Product p, String kategori) {
    if (kategori == 'Semua Produk') return true;

    final nama = p.title.toLowerCase();
    final jenis = p.category.toLowerCase();

    switch (kategori) {
      case 'Sayuran':
        return jenis.contains('sayur') ||
            jenis.contains('vegetable') ||
            [
              'sayur',
              'tomat',
              'bayam',
              'kangkung',
              'wortel',
              'terong',
            ].any(nama.contains);

      case 'Buah':
        return jenis.contains('buah') ||
            jenis.contains('fruit') ||
            [
              'buah',
              'apel',
              'jeruk',
              'mangga',
              'pisang',
              'anggur',
            ].any(nama.contains);

      case 'Bibit':
        return jenis.contains('bibit') ||
            jenis.contains('benih') ||
            jenis.contains('seed') ||
            nama.contains('bibit') ||
            nama.contains('benih');

      case 'Alat':
        return jenis.contains('alat') ||
            jenis.contains('tools') ||
            jenis.contains('equipment') ||
            nama.contains('alat');

      case 'Pupuk':
        return jenis.contains('pupuk') ||
            jenis.contains('fertilizer') ||
            nama.contains('pupuk');

      default:
        return true;
    }
  }

  List<Product> _filterProduk(List<Product> semua, String kategori) {
    final hasil = semua.where((p) {
      final cocokKategori = _sesuaiKategori(p, kategori);
      final cocokCari = p.title.toLowerCase().contains(
            _kataKunci.toLowerCase(),
          );
      final cocokStok = !_stokTersediaSaja || p.stock > 0;

      return cocokKategori && cocokCari && cocokStok;
    }).toList();

    if (_hargaTermurah) {
      hasil.sort((a, b) => a.price.compareTo(b.price));
    }

    return hasil;
  }

  String _rupiah(num harga) {
    final angka = harga.toInt().toString();
    final hasil = StringBuffer();

    for (int i = 0; i < angka.length; i++) {
      hasil.write(angka[i]);
      final sisa = angka.length - i - 1;

      if (sisa > 0 && sisa % 3 == 0) {
        hasil.write('.');
      }
    }

    return 'Rp ${hasil.toString()}';
  }

  String _formatWaktu(DateTime waktu) {
    final jam = waktu.hour.toString().padLeft(2, '0');
    final menit = waktu.minute.toString().padLeft(2, '0');

    return '$jam:$menit WIB';
  }

  Widget _buildFilterKategori() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      color: scheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori produk',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final nama in _kategori)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(nama),
                      selected: _kategoriAktif == nama,
                      showCheckmark: false,
                      onSelected: (_) {
                        final index = _kategori.indexOf(nama);
                        _tabController.animateTo(index);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _cariController,
            style: text.bodyLarge,
            onChanged: (value) {
              setState(() => _kataKunci = value);
            },
            decoration: InputDecoration(
              hintText: 'Cari nama produk...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _kataKunci.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _cariController.clear();
                        setState(() => _kataKunci = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                avatar: const Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                ),
                label: const Text('Stok tersedia'),
                selected: _stokTersediaSaja,
                onSelected: (value) {
                  setState(() => _stokTersediaSaja = value);
                },
              ),
              FilterChip(
                avatar: const Icon(
                  Icons.payments_outlined,
                  size: 18,
                ),
                label: const Text('Harga termurah'),
                selected: _hargaTermurah,
                onSelected: (value) {
                  setState(() => _hargaTermurah = value);
                },
              ),
            ],
          ),
          if (_terakhirDiperbarui != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Terakhir diperbarui: '
                    '${_formatWaktu(_terakhirDiperbarui!)}',
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: scheme.primary),
          const SizedBox(height: 12),
          const Text('Mengambil data produk...'),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 52,
              color: scheme.error,
            ),
            const SizedBox(height: 12),
            const Text('Data produk gagal dimuat'),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKartuProduk(Product p) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.detailProduk,
            arguments: p.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: scheme.surfaceContainerHighest,
                child: p.thumbnail.isEmpty
                    ? Icon(
                        Icons.image_not_supported_outlined,
                        size: 50,
                        color: scheme.onSurfaceVariant,
                      )
                    : Image.network(
                        p.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _rupiah(p.price),
                    style: text.titleMedium?.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Stok: ${p.stock}',
                    style: text.bodySmall?.copyWith(
                      color: p.stock > 0
                          ? scheme.onSurface
                          : scheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Lihat detail',
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<Product> semua) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final produk = _filterProduk(semua, _kategoriAktif);

    if (produk.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 56,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                'Produk tidak ditemukan',
                style: text.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Coba kata kunci atau kategori lain.',
                style: text.bodyMedium,
              ),
              TextButton(
                onPressed: () {
                  _cariController.clear();
                  setState(() => _kataKunci = '');
                },
                child: const Text('Hapus pencarian'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _kategoriAktif,
                  style: text.titleLarge,
                ),
              ),
              Text(
                '${produk.length} produk',
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final lebar = constraints.maxWidth;

              final kolom = lebar >= 1100
                  ? 4
                  : lebar >= 700
                      ? 3
                      : lebar >= 380
                          ? 2
                          : 1;

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kolom,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: kolom == 1 ? 1.25 : 0.70,
                ),
                itemCount: produk.length,
                itemBuilder: (context, index) {
                  return _buildKartuProduk(produk[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriSamping() {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      width: 205,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          right: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 12, 14),
            child: Text(
              'KATEGORI PRODUK',
              style: text.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _kategori.length,
              itemBuilder: (context, index) {
                final terpilih = _tabController.index == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: ListTile(
                    selected: terpilih,
                    selectedTileColor: scheme.secondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(
                      _ikonKategori[index],
                      color: terpilih
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                    title: Text(
                      _kategori[index],
                      style: text.bodyMedium?.copyWith(
                        color: terpilih
                            ? scheme.primary
                            : scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () => _tabController.animateTo(index),
                  ),
                );
              },
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final layarLebar = constraints.maxWidth >= 850;

        return Scaffold(
          backgroundColor: scheme.surface,
          appBar: AppBar(
            title: Text(
              'Katalog Produk',
              style: text.titleLarge?.copyWith(
                color: scheme.onSurface,
              ),
            ),
            backgroundColor: scheme.surfaceContainerLow,
            foregroundColor: scheme.onSurface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                tooltip: _sedangMemuatUlang
                    ? 'Memuat produk...'
                    : 'Muat ulang produk',
                onPressed:
                    _sedangMemuatUlang ? null : _muatUlang,
                icon: _sedangMemuatUlang
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Icon(Icons.refresh),
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: scheme.outlineVariant,
              ),
            ),
          ),
          body: FutureBuilder<List<Product>>(
            future: _produkFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                      ConnectionState.waiting &&
                  !snapshot.hasData) {
                return _buildLoading();
              }

              if (snapshot.hasError && !snapshot.hasData) {
                return _buildError(snapshot.error!);
              }

              final semua = snapshot.data ?? [];

              return Row(
                children: [
                  if (layarLebar) _buildKategoriSamping(),
                  Expanded(
                    child: Column(
                      children: [
                        _buildFilterPanel(),
                        _buildFilterKategori(),
                        Expanded(
                          child: _buildProductList(semua),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
