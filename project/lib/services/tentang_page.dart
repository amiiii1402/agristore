
import 'package:flutter/material.dart';

import '../api_config.dart';
import '../routes/app_routes.dart';
import '../theme/theme_controller.dart';
import 'product_service.dart';

class TentangPage extends StatefulWidget {
  const TentangPage({super.key});

  @override
  State<TentangPage> createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
  bool _memeriksa = false;
  bool _berhasil = false;
  String? _status;

  Future<void> _cekKoneksi() async {
    setState(() {
      _memeriksa = true;
      _status = null;
    });

    try {
      final pesan = await ProductService.checkHealth();

      if (!mounted) return;

      setState(() {
        _memeriksa = false;
        _berhasil = true;
        _status = pesan;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _memeriksa = false;
        _berhasil = false;
        _status = error.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  Widget _buildPilihTema() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        return SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_outlined),
                label: Text('Terang'),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto_outlined),
                label: Text('Sistem'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined),
                label: Text('Gelap'),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (pilihan) {
              ThemeController.ubah(pilihan.first);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: AppBar(
        title: Text(
          'Info Aplikasi',
          style: text.titleLarge?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        backgroundColor: scheme.surfaceContainerLow,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
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
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(
                Icons.agriculture,
                color: scheme.primary,
                size: 32,
              ),
              title: const Text(
                'AgriStore',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Versi 1.0.0 | Prototipe Pertemuan 9',
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Pengaturan Tampilan',
            style: text.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih tampilan aplikasi sesuai kenyamananmu.',
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mode Tema',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPilihTema(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: Icon(
                Icons.palette_outlined,
                color: scheme.primary,
              ),
              title: const Text('Style guide komponen'),
              subtitle: const Text(
                'Warna, tipografi, dan komponen AgriStore',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.styleGuide,
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Koneksi Server',
            style: text.titleLarge,
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: Icon(
                Icons.dns_outlined,
                color: scheme.primary,
              ),
              title: const Text('Base URL API'),
              subtitle: SelectableText(ApiConfig.baseUrl),
            ),
          ),

          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: _memeriksa ? null : _cekKoneksi,
            icon: _memeriksa
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.wifi_tethering),
            label: Text(
              _memeriksa
                  ? 'Memeriksa...'
                  : 'Cek koneksi API',
            ),
          ),

          if (_status != null) ...[
            const SizedBox(height: 12),
            Card(
              color: _berhasil
                  ? scheme.primaryContainer
                  : scheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  _berhasil
                      ? Icons.check_circle
                      : Icons.error_outline,
                  color: _berhasil
                      ? scheme.onPrimaryContainer
                      : scheme.onErrorContainer,
                ),
                title: Text(
                  _berhasil
                      ? 'Terhubung'
                      : 'Gagal terhubung',
                ),
                subtitle: Text(_status!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
