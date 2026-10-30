
import 'package:flutter/material.dart';

import 'models/product.dart';
import 'services/product_service.dart';
import 'routes/app_routes.dart';

class BerandaAgriStore extends StatefulWidget {
  final ValueChanged<String>? onPilihKategori;
  final VoidCallback? onPilihanProduk;
  final VoidCallback? onDataProduk;
  final VoidCallback? onCariProduk;

  const BerandaAgriStore({
    super.key,
    this.onPilihKategori,
    this.onPilihanProduk,
    this.onDataProduk,
    this.onCariProduk,
  });

  @override
  State<BerandaAgriStore> createState() => _BerandaAgriStoreState();
}

class _BerandaAgriStoreState extends State<BerandaAgriStore> {
  late Future<List<Product>> _produkFuture;

  final List<Map<String, dynamic>> _kategori = [
    {
      'nama': 'Sayuran',
      'ikon': Icons.eco_outlined,
      'warna': const Color(0xFFB9F6CA),
    },
    {
      'nama': 'Buah',
      'ikon': Icons.spa_outlined,
      'warna': const Color(0xFFDCE7FF),
    },
    {
      'nama': 'Bibit',
      'ikon': Icons.grass,
      'warna': const Color(0xFFD9F0D5),
    },
    {
      'nama': 'Pupuk',
      'ikon': Icons.compost_outlined,
      'warna': const Color(0xFFE1E7F8),
    },
    {
      'nama': 'Alat',
      'ikon': Icons.agriculture_outlined,
      'warna': const Color(0xFFD7F0E9),
    },
  ];

  @override
  void initState() {
    super.initState();
    _produkFuture = ProductService.fetchProducts();
  }

  void _muatUlang() {
    setState(() {
      _produkFuture = ProductService.fetchProducts();
    });
  }

  Future<void> _refreshProduk() async {
    final futureBaru = ProductService.fetchProducts();

    setState(() {
      _produkFuture = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {
      // Kesalahan ditampilkan oleh FutureBuilder.
    }
  }

  void _bukaKategori(String kategori) {
    widget.onPilihKategori?.call(kategori);
  }

  void _bukaKatalog() {
    if (widget.onPilihanProduk != null) {
      widget.onPilihanProduk!();
    } else {
      _bukaKategori('Semua Produk');
    }
  }

  void _bukaDetail(Product produk) {
    Navigator.pushNamed(
      context,
      AppRoutes.detailProduk,
      arguments: produk.id,
    );
  }

  Widget _judulBagian(
    BuildContext context,
    String judul, {
    String? aksi,
    VoidCallback? onAksi,
  }) {
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            judul,
            style: text.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (aksi != null)
          TextButton(
            onPressed: onAksi,
            child: Row(
              children: [
                Text(aksi),
                const SizedBox(width: 3),
                const Icon(Icons.chevron_right, size: 19),
              ],
            ),
          ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 17,
              color: scheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'SELAMAT DATANG DI AGRISTORE',
              style: text.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: Text(
                'Selamat Datang, Petani Muda!',
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              child: Icon(
                Icons.eco,
                color: scheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          'Temukan kebutuhan pertanianmu di sini 🌱',
          style: text.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _bannerPromo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF087F68),
            Color(0xFF176C49),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF087F68).withValues(alpha: 0.18),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🌿  AGRISTORE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Kebutuhan Pertanian, Lebih Mudah!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Temukan berbagai produk pertanian berkualitas.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _bukaKatalog,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF087F68),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 11,
                    ),
                  ),
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 17,
                  ),
                  label: const Text(
                    'Belanja Sekarang',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Icon(
              Icons.local_florist,
              size: 100,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kategoriPilihan(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _judulBagian(
          context,
          'Kategori Pilihan',
          aksi: 'Lihat Semua',
          onAksi: _bukaKatalog,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _kategori.length,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final item = _kategori[index];
              final nama = item['nama'] as String;
              final warna = item['warna'] as Color;
              final ikon = item['ikon'] as IconData;

              return SizedBox(
                width: 68,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _bukaKategori(nama),
                  child: Column(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: warna,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          ikon,
                          color: const Color(0xFF087F68),
                          size: 29,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        nama == 'Alat' ? 'Alat Tani' : nama,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _kartuProduk(BuildContext context, Product produk) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _bukaDetail(produk),
        child: SizedBox(
          width: 175,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: scheme.surfaceContainerHighest,
                      child: produk.thumbnail.isEmpty
                          ? Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: scheme.onSurfaceVariant,
                            )
                          : Image.network(
                              produk.thumbnail,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_not_supported_outlined,
                                size: 45,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                    Positioned(
                      top: 9,
                      left: 9,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB9F6CA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          produk.stock > 0 ? 'Tersedia' : 'Habis',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF176C49),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          produk.rating > 0
                              ? produk.rating.toStringAsFixed(1)
                              : 'Belum ada rating',
                          style: text.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      produk.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      produk.hargaRupiah,
                      style: text.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stok: ${produk.stock}',
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _produkPilihan(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<Product>>(
      future: _produkFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_off_outlined, size: 38),
                const SizedBox(height: 8),
                const Text('Produk gagal dimuat'),
                TextButton.icon(
                  onPressed: _muatUlang,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final produk = snapshot.data ?? [];

        if (produk.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text('Belum ada produk tersedia.'),
            ),
          );
        }

        return SizedBox(
          height: 285,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: produk.length > 8 ? 8 : produk.length,
            separatorBuilder: (_, __) => const SizedBox(width: 13),
            itemBuilder: (context, index) {
              return _kartuProduk(context, produk[index]);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.sizeOf(context).width;
    final padding = lebar < 500 ? 16.0 : 24.0;

    return RefreshIndicator(
      onRefresh: _refreshProduk,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(padding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                const SizedBox(height: 24),
                _bannerPromo(context),
                const SizedBox(height: 20),
                _kategoriPilihan(context),
                const SizedBox(height: 20),
                _judulBagian(
                  context,
                  'Produk Pilihan',
                  aksi: 'Semua',
                  onAksi: _bukaKatalog,
                ),
                const SizedBox(height: 12),
                _produkPilihan(context),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: widget.onDataProduk ?? _bukaKatalog,
                    icon: const Icon(Icons.inventory_2_outlined),
                    label: const Text('Lihat Semua Data Produk'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
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
