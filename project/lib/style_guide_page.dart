
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

// Halaman untuk mendokumentasikan token dan komponen UI AgriStore.
class StyleGuidePage extends StatelessWidget {
  const StyleGuidePage({super.key});

  Widget _judul(BuildContext context, String teks) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Text(
        teks,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _warna(String nama, Color latar, Color isi, Color garis) {
    return Container(
      width: 150,
      height: 64,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: garis),
      ),
      child: Text(
        nama,
        style: TextStyle(
          color: isi,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _contohRadius(
    BuildContext context, {
    required String nama,
    required double nilai,
    required Color warna,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nama,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${nilai.toInt()} px',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: warna,
            borderRadius: BorderRadius.circular(nilai),
          ),
          alignment: Alignment.center,
          child: Text(
            nama,
            style: TextStyle(
              color: scheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final garis = scheme.outlineVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Guide AgriStore'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          _judul(context, '1. Warna (ColorScheme)'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _warna('primary', scheme.primary, scheme.onPrimary, garis),
              _warna(
                'primaryContainer',
                scheme.primaryContainer,
                scheme.onPrimaryContainer,
                garis,
              ),
              _warna(
                'secondaryContainer',
                scheme.secondaryContainer,
                scheme.onSecondaryContainer,
                garis,
              ),
              _warna('tertiary', scheme.tertiary, scheme.onTertiary, garis),
              _warna('surface', scheme.surface, scheme.onSurface, garis),
              _warna('error', scheme.error, scheme.onError, garis),
            ],
          ),

          _judul(context, '2. Tipografi (TextTheme)'),
          Text('headlineSmall - Oswald', style: text.headlineSmall),
          Text('titleLarge - Oswald', style: text.titleLarge),
          Text('titleMedium - judul kartu', style: text.titleMedium),
          Text('bodyMedium - teks isi', style: text.bodyMedium),
          Text('labelLarge - label tombol', style: text.labelLarge),

          _judul(context, '3. Spasi dan Radius'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Standar jarak dan sudut komponen AgriStore.',
                    style: text.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  _contohRadius(
                    context,
                    nama: 'Radius utama',
                    nilai: AppTheme.radius,
                    warna: scheme.primaryContainer,
                  ),
                  const SizedBox(height: 20),
                  _contohRadius(
                    context,
                    nama: 'Radius kecil',
                    nilai: AppTheme.radiusKecil,
                    warna: scheme.secondaryContainer,
                  ),
                ],
              ),
            ),
          ),

          _judul(context, '4. Tombol'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text('Filled'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Text'),
              ),
              const FilledButton(
                onPressed: null,
                child: Text('Nonaktif'),
              ),
            ],
          ),

          _judul(context, '5. Input dan Chip'),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Nama pembeli',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Sayuran'),
                selected: true,
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: const Text('Bibit'),
                selected: false,
                onSelected: (_) {},
              ),
              const Chip(
                avatar: Icon(Icons.local_shipping_outlined),
                label: Text('Gratis ongkir'),
              ),
            ],
          ),

          _judul(context, '6. Kartu dan Badge'),
          Card(
            child: ListTile(
              leading: Badge.count(
                count: 3,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              title: const Text('Card + ListTile'),
              subtitle: const Text('Sudut 16, garis outlineVariant'),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('SnackBar mengambang (floating)'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
            label: const Text('Tampilkan SnackBar'),
          ),
        ],
      ),
    );
  }
}
