
import 'package:flutter/material.dart';

import '../beranda_page.dart';
import '../daftar_produk_page.dart';
import '../form_pesanan_page.dart';
import '../pencarian_produk_page.dart';
import 'product_service.dart';
import 'tentang_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  static const double lebarKontenMaksimum = 1440;

  int _indexAktif = 0;
  int? _jumlahProduk;
  int _versiKatalog = 0;
  String _kategoriPilihan = 'Semua Produk';
  bool _pesananSudahDibuka = false;

  late final List<Widget?> _halaman;

  @override
  void initState() {
    super.initState();

    _halaman = [
      BerandaAgriStore(
        onPilihKategori: _bukaKategori,
        onPilihanProduk: _bukaSemuaProduk,
        onDataProduk: _bukaDataProduk,
      ),
      _buatKatalog(),
      null,
      const TentangPage(),
    ];

    _muatJumlahProduk();
  }

  Widget _buatKatalog() {
    return DaftarProdukPage(
      key: ValueKey('$_kategoriPilihan-$_versiKatalog'),
      kategoriAwal: _kategoriPilihan,
    );
  }

  Future<void> _muatJumlahProduk() async {
    try {
      final produk = await ProductService.fetchProducts();

      if (!mounted) return;

      setState(() {
        _jumlahProduk = produk.length;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _jumlahProduk = null;
      });
    }
  }

  void _bukaKategori(String kategori) {
    setState(() {
      _kategoriPilihan = kategori;
      _indexAktif = 1;
      _halaman[1] = _buatKatalog();
    });
  }

  void _bukaSemuaProduk() {
    _bukaKategori('Semua Produk');
  }

  void _bukaDataProduk() {
    setState(() {
      _kategoriPilihan = 'Semua Produk';
      _versiKatalog++;
      _indexAktif = 1;
      _halaman[1] = _buatKatalog();
    });

    _muatJumlahProduk();
  }

  void _pindahHalaman(int index) {
    setState(() {
      _indexAktif = index;

      if (index == 1 && _halaman[1] == null) {
        _halaman[1] = _buatKatalog();
      }

      if (index == 2 && !_pesananSudahDibuka) {
        _halaman[2] = const FormPesananPage();
        _pesananSudahDibuka = true;
      }
    });
  }

  Future<void> _bukaPencarian() async {
    final kategori = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: '/produk/cari'),
        builder: (context) => const PencarianProdukPage(),
      ),
    );

    if (!mounted || kategori == null) return;

    _bukaKategori(kategori);
  }

  // Badge jumlah produk pada menu Katalog.
  Widget _ikonKatalog(ColorScheme scheme) {
    return Badge(
      isLabelVisible: _jumlahProduk != null,
      label: Text('${_jumlahProduk ?? 0}'),
      backgroundColor: scheme.primary,
      textColor: scheme.onPrimary,
      child: const Icon(Icons.storefront_outlined),
    );
  }

  List<NavigationDestination> _destinasi(ColorScheme scheme) => [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        NavigationDestination(
          icon: _ikonKatalog(scheme),
          selectedIcon: _ikonKatalog(scheme),
          label: 'Katalog',
        ),
        const NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Pesanan',
        ),
        const NavigationDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: 'Tentang',
        ),
      ];

  void _bukaInfo(BuildContext drawerContext) {
    Navigator.pop(drawerContext);
    _pindahHalaman(3);
  }

  Future<void> _konfirmasiKeluar(BuildContext drawerContext) async {
    Navigator.pop(drawerContext);

    final keluar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.logout_rounded),
        title: const Text('Kembali ke Beranda'),
        content: const Text(
          'Apakah kamu ingin kembali ke halaman Beranda?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (keluar == true && mounted) {
      _pindahHalaman(0);
    }
  }

  Widget _buatDrawer(ColorScheme scheme) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary,
                    scheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: const Text(
                'AgriStore',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('Kebutuhan pertanianmu'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: scheme.onPrimary,
                child: Icon(
                  Icons.eco,
                  size: 34,
                  color: scheme.primary,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Info'),
              subtitle: const Text('Informasi aplikasi'),
              onTap: () => _bukaInfo(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              subtitle: const Text('Kembali ke Beranda'),
              onTap: () => _konfirmasiKeluar(context),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'AgriStore • Aplikasi Produk Pertanian',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buatNavigationRail(ColorScheme scheme) {
    return NavigationRail(
      selectedIndex: _indexAktif,
      onDestinationSelected: _pindahHalaman,
      labelType: NavigationRailLabelType.all,
      groupAlignment: -0.7,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Icon(
          Icons.eco,
          color: scheme.primary,
          size: 32,
        ),
      ),
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Beranda'),
        ),
        NavigationRailDestination(
          icon: _ikonKatalog(scheme),
          selectedIcon: _ikonKatalog(scheme),
          label: const Text('Katalog'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: Text('Pesanan'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: Text('Tentang'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final layarLebar = constraints.maxWidth >= 700;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 20,
            title: const Row(
              children: [
                Icon(Icons.eco, size: 27),
                SizedBox(width: 10),
                Text(
                  'AgriStore',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            elevation: 0,
            actions: [
              IconButton(
                tooltip: 'Cari produk',
                onPressed: _bukaPencarian,
                icon: const Icon(Icons.search),
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: _buatDrawer(scheme),
          body: Row(
            children: [
              if (layarLebar) _buatNavigationRail(scheme),
              Expanded(
                child: ColoredBox(
                  color: scheme.surface,
                  child: Center(
                    child: SizedBox(
                      width: constraints.maxWidth > lebarKontenMaksimum
                          ? lebarKontenMaksimum
                          : double.infinity,
                      child: IndexedStack(
                        index: _indexAktif,
                        children: List.generate(
                          _halaman.length,
                          (index) =>
                              _halaman[index] ?? const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: layarLebar
              ? null
              : NavigationBar(
                  selectedIndex: _indexAktif,
                  onDestinationSelected: _pindahHalaman,
                  destinations: _destinasi(scheme),
                ),
        );
      },
    );
  }
}
