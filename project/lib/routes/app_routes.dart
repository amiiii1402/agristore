
import 'package:flutter/material.dart';

import '../checkout_page.dart';
import '../detail_produk_page.dart';
import '../models/ringkasan_pesanan.dart';
import '../pencarian_produk_page.dart';
import '../pesanan_berhasil_page.dart';
import '../services/main_shell_page.dart';
import '../style_guide_page.dart';

class CheckoutArgs {
  final String namaProduk;
  final String harga;
  final String kategori;

  const CheckoutArgs({
    required this.namaProduk,
    required this.harga,
    required this.kategori,
  });
}

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String cariProduk = '/produk/cari';
  static const String detailProduk = '/produk/detail';
  static const String checkout = '/checkout';
  static const String pesananBerhasil = '/pesanan/berhasil';
  static const String styleGuide = '/style-guide';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _page(settings, const MainShellPage());

      case cariProduk:
        return _page(settings, const PencarianProdukPage());

      case detailProduk:
        final args = settings.arguments;

        if (args is int) {
          return _page(
            settings,
            DetailProdukPage(id: args),
          );
        }

        return _page(
          settings,
          const RuteTidakValidPage('ID produk tidak valid.'),
        );

      case checkout:
        final args = settings.arguments;

        if (args is CheckoutArgs) {
          return _page(
            settings,
            CheckoutPage(
              namaProduk: args.namaProduk,
              harga: args.harga,
              kategori: args.kategori,
            ),
          );
        }

        return _page(
          settings,
          const RuteTidakValidPage('Data checkout tidak valid.'),
        );

      case pesananBerhasil:
        final args = settings.arguments;

        if (args is RingkasanPesanan) {
          return _page(
            settings,
            PesananBerhasilPage(ringkasan: args),
          );
        }

        return _page(
          settings,
          const RuteTidakValidPage('Data pesanan tidak valid.'),
        );

      case styleGuide:
        return _page(settings, const StyleGuidePage());

      default:
        return _page(
          settings,
          const RuteTidakValidPage(
            'Halaman yang kamu cari tidak ditemukan.',
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _page(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (context) => page,
    );
  }
}

class RuteTidakValidPage extends StatelessWidget {
  final String pesan;

  const RuteTidakValidPage(this.pesan, {super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman tidak tersedia'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: scheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                pesan,
                textAlign: TextAlign.center,
                style: text.bodyLarge,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
